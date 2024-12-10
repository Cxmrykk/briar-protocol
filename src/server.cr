require "openssl_ext"
require "openssl"
require "base64"
require "socket"
require "log"
require "dns"

require "./handler"
require "./packets"
require "./buffer"

require "./common/auth"
require "./common/crypt"

class ClientData
  class KeepAlive
    property id : Int32
    property timestamp : Time::Span
    property channel : Channel(Int32)
    property ready : Bool

    def initialize
      @id = 0
      @timestamp = 0.seconds
      @channel = Channel(Int32).new
      @ready = false
    end
  end

  alias Encryption = NamedTuple(
    encryptor: OpenSSL::Cipher,
    decryptor: OpenSSL::Cipher,
  )

  property keep_alive : KeepAlive
  property state : ProtocolState
  property socket : TCPSocket

  property username : String?
  property uuid : String?
  property encryption : Encryption?
  property properties : Array(JSON::Any)?

  def initialize(@state : ProtocolState, @socket : TCPSocket)
    @keep_alive = KeepAlive.new
  end
end

class Server < ServerHandler
  include Packets

  PROTOCOL_VERSION_S  = "1.8.9"
  PROTOCOL_VERSION    = 47
  BUFFER_SIZE         = 1024 * 1024
  KEEP_ALIVE_INTERVAL = 5000.milliseconds

  alias Encryption = NamedTuple(
    pkey: OpenSSL::PKey::RSA,
    public_key: Bytes,
    verify_token: Bytes,
  )

  getter server : TCPServer?
  getter encryption : Encryption?

  getter compression : Int32
  getter keep_alive : Time::Span
  getter clients : Hash(String, ClientData)
  getter encryption_enabled : Bool

  def initialize(@encryption_enabled : Bool = false, @compression : Int32 = -1, @keep_alive : Time::Span = 30.seconds)
    super()
    @clients = Hash(String, ClientData).new
    @parser.compression = @compression
  end

  def start(port : Int32 = 25565)
    # Generate a new 1024-bit RSA key pair
    if @encryption_enabled
      Log.debug { "Encryption enabled, a new RSA keypair will be generated" }
      pkey = OpenSSL::PKey::RSA.new(1024)

      # Get the public key from the key pair (extract to DER)
      public_key = (
        if key = pkey.public_key.to_pem.match(/-----BEGIN PUBLIC KEY-----\n(.*)\n-----END PUBLIC KEY-----/m)
          Base64.decode(key[1])
        else
          raise "Invalid PEM public key generated (critical error)"
        end
      )

      # Generate a random verify token (used to verify encryption works)
      verify_token = Random::Secure.random_bytes(16)

      @encryption = Encryption.new(
        pkey: pkey,
        public_key: public_key,
        verify_token: verify_token,
      )
    end

    # Start the TCP server on specified port
    @server = TCPServer.new(port)
    Log.debug { "Server listening on port #{port}" }

    # Accept new client connections until stopped
    accept_clients
  end

  def accept_clients
    while server = @server
      begin
        while client = server.accept
          # Use temporary username until Login Start
          id = client.remote_address.to_s
          Log.debug { "Client \"#{id}\": New connection" }

          @clients[id] = ClientData.new(
            state: ProtocolState::Handshaking,
            socket: client
          )

          spawn {
            read(id)
          }
        end
      rescue ex
        Log.error { "Error accepting client: #{ex}" }
      end
    end
  end

  def write(id, packet : RawPacket)
    return if @clients[id]?.nil?

    socket = @clients[id].socket
    return if socket.closed?

    data = @parser.format(packet)

    # Encrypt message with shared secret if encryption is enabled
    @clients[id].encryption.try do |encryption|
      data = Crypt.encrypt(
        cipher: encryption[:encryptor],
        data: data
      )
    end

    socket.write(data)
  end

  def read(id)
    socket = @clients[id].socket

    until socket.closed? || @clients[id]?.nil?
      buffer = Bytes.empty
      excess = false

      # Continue reading incoming data
      until socket.closed? || @clients[id]?.nil?
        temp = Bytes.new(BUFFER_SIZE)

        # Skip read to prevent lockup when no new data is available
        unless excess
          bytes_read = begin
            socket.read(temp)
          rescue ex : IO::Error
            self.close(id)
            Log.debug { "Client \"#{id}\": Got IO::Error in TCPSocket::read: \"#{ex.to_s}\"" }
            return
          end

          # Server has closed the connnection
          if bytes_read == 0
            self.close(id)
            Log.debug { "Client \"#{id}\": Connection was closed (bytes_read == 0)" }
            return
          end

          temp = temp[0, bytes_read]

          # Decrypt message with shared secret if encryption is enabled
          @clients[id].encryption.try do |encryption|
            temp = Crypt.decrypt(
              cipher: encryption[:decryptor],
              data: temp
            )
          end

          buffer += temp
        else
          repeating = false
        end

        # Determine how much of a packet we have received
        length = PacketBuffer.new(buffer).read_var_int
        length_size = PacketBuffer.var_int_size(length)
        remaining = length - (buffer.size - length_size)

        if remaining == 0
          # Complete; Received packet length matches length header
          self.handle(id, @clients[id].state, buffer)
          break
        elsif remaining > 0
          # Incomplete; Received packet is smaller than length header
          next
        else
          # Excess; Received packet contains whole packet with excess data
          excess = true
          bytes_available = length_size + length
          formed = buffer[0, bytes_available]
          buffer = buffer[bytes_available..]
          self.handle(id, @clients[id].state, formed)
          next
        end
      end
    end
  end

  def close(id)
    unless @clients[id]?.nil?
      @clients[id].socket.close
      @clients.delete(id)
    end
  end

  def keep_alive(id)
    until @clients[id]?.nil?
      @clients[id].keep_alive.ready = true
      @clients[id].keep_alive.id = Random.rand(Int32)
      @clients[id].keep_alive.timestamp = Time.monotonic
      self.write(id, Play::C::KeepAlive.new(@clients[id].keep_alive.id))

      loop do
        select
        when keep_alive_id = @clients[id].keep_alive.channel.receive
          if keep_alive_id == @clients[id].keep_alive.id
            @clients[id].keep_alive.ready = false
            span = KEEP_ALIVE_INTERVAL - (Time.monotonic - @clients[id].keep_alive.timestamp)
            sleep(span) if span > Time::Span.zero
            break
          end
        when timeout(@keep_alive)
          self.close(id)
          break
        end
      end
    end
  end

  #
  # EventEmitter functions
  #

  def on
    @emitter.on
  end

  def once
    @emitter.once
  end

  def receive
    @emitter.receive
  end

  #
  # Packet handlers
  #

  def handle(id, packet : Handshaking::S::Handshake)
    state = ProtocolState.from_value?(packet.next_state)
    Log.debug { "Rejecting handshake from client \"#{id}\": Invalid protocol state" } if state.nil?
    return if state.nil?

    @clients[id].state = state
    return if packet.protocol_version == PROTOCOL_VERSION

    Log.debug { "Rejecting handshake from client \"#{id}\": Protocol mismatch (Expected #{PROTOCOL_VERSION}, got #{packet.protocol_version})" }

    if @clients[id].state == ProtocolState::Login
      self.write(id, Login::C::LoginDisconnect.new("Invalid version! Join on #{PROTOCOL_VERSION_S}."))
    end

    self.close(id)
  end

  def handle(id, packet : Login::S::LoginStart)
    @clients[id].username = packet.name

    # Use compression if enabled
    if @compression > 0
      self.write(id, Login::C::EnableCompression.new(@compression))
    end

    # Send authentication if encryption enabled
    if encryption = @encryption
      encryption_request = Login::C::EncryptionRequest.new(
        server_id: "",
        public_key_length: encryption[:public_key].size,
        public_key: encryption[:public_key],
        verify_token_length: encryption[:verify_token].size,
        verify_token: encryption[:verify_token],
      )

      self.write(id, encryption_request)
    else
      # Set ProtocolState to play
      @clients[id].state = ProtocolState::Play

      # Generate random UUID
      @clients[id].uuid = UUID.random.to_s

      # Send login success packet
      login_success = Login::C::LoginSuccess.new(
        uuid: @clients[id].uuid.not_nil!,
        username: @clients[id].username.not_nil!
      )

      self.write(id, login_success)

      # Start keep alive packet exchange
      spawn {
        keep_alive(id)
      }
    end
  end

  def handle(id, packet : Login::S::EncryptionResponse)
    @encryption.try do |encryption|
      shared_secret = encryption[:pkey].private_decrypt(packet.shared_secret, LibCrypto::Padding::PKCS1_PADDING)
      verify_token = encryption[:pkey].private_decrypt(packet.verify_token, LibCrypto::Padding::PKCS1_PADDING)

      # Verify token match, encryption is working properly
      if verify_token == encryption[:verify_token]
        @clients[id].encryption = ClientData::Encryption.new(
          encryptor: Crypt.encryptor("aes-128-cfb8", shared_secret),
          decryptor: Crypt.decryptor("aes-128-cfb8", shared_secret),
        )

        # Query authentication server
        session = (
          if username = @clients[id].username
            server_hash = Crypt.generate_server_hash("", shared_secret, encryption[:public_key]) # Empty server ID
            ServerAuth.get_session?(username, server_hash)
          end
        )

        # Session is valid; Send login success
        unless session.nil?
          @clients[id].username = session[:name]
          @clients[id].uuid = session[:uuid].to_s
          @clients[id].properties = session[:properties]

          # Set ProtocolState to play
          @clients[id].state = ProtocolState::Play

          # Send login success packet
          login_success = Login::C::LoginSuccess.new(
            uuid: @clients[id].uuid.not_nil!,
            username: @clients[id].username.not_nil!
          )

          self.write(id, login_success)

          # Start keep alive packet exchange
          spawn {
            keep_alive(id)
          }

          Log.debug { "User \"#{session[:name]}\" joined with UUID \"#{@clients[id].uuid.not_nil!}\"" }
        end
      end
    end
  end

  def handle(id, packet : Status::S::Ping)
    self.write(id, Status::C::Pong.new(packet.payload))
  end

  def handle(id, packet : Play::S::KeepAlive)
    if @clients[id].keep_alive.ready
      @clients[id].keep_alive.channel.send(packet.keep_alive_id)
    end
  end
end
