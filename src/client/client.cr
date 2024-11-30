require "openssl_ext"
require "openssl"
require "base64"
require "socket"
require "log"
require "dns"

require "./auth"
require "./disk"
require "./crypt"

require "../handler"
require "../packets"
require "../buffer"

class Client < ClientHandler
  include Packets

  PROTOCOL_VERSION = 47
  BUFFER_SIZE      = 1024 * 1024

  class LoginDisconnect < Exception; end

  class PlayDisconnect < Exception; end

  class ConnectionClosed < Exception; end

  class InvalidAuth < Exception; end

  alias Authentication = NamedTuple(
    access_token: String,
    uuid: String,
  )

  alias Encryption = NamedTuple(
    shared_secret: Bytes,
    encryptor: OpenSSL::Cipher,
    decryptor: OpenSSL::Cipher,
  )

  @email : String?
  @username : String?

  @state : ProtocolState
  @socket : TCPSocket?
  @authentication : Authentication?
  @encryption : Encryption?

  def initialize(username : String, @password : String? = nil)
    super()
    # Attempt authentication (cache encryption key was specified)
    @email = username if @password

    # Offline mode, username is actual username
    @username = username unless @password

    # Initialize handshaking
    @state = ProtocolState::Handshaking
  end

  def authenticate
    if @password.nil?
      raise InvalidAuth.new("Cannot authenticate without specifying a password.")
    end

    email = @email.not_nil!
    password = @password.not_nil!

    # Get the refresh token from disk cache (if present)
    refresh_token = Disk.read_token?(email, password)

    # Authenticate using MSA
    result = Authenticator.auth(email, refresh_token)

    # Save the updated refresh token to disk cache
    Disk.write_token(email, password, result[:refresh_token])

    # Use relevant data
    @username = result[:profile]["name"].as_s
    @authentication = {
      access_token: result[:access_token],
      uuid:         result[:profile]["id"].as_s,
    }
  end

  def get_length_header(data : Bytes)
    PacketBuffer.new(data).read_var_int
  end

  def write(packet : RawPacket)
    socket = @socket
    return if socket.nil? || socket.closed?

    data = @parser.format(packet)

    # Encrypt message with shared secret if encryption is enabled
    @encryption.try do |encryption|
      data = Crypt.encrypt(
        cipher: encryption[:encryptor],
        data: data
      )
    end

    socket.write(data)
  end

  def read
    while socket = @socket
      until socket.closed?
        buffer = Bytes.empty

        # Continue reading incoming data
        until socket.nil? || socket.closed?
          temp = Bytes.new(BUFFER_SIZE)

          # Read incoming TCP stream
          bytes_read = begin
            socket.read(temp)
          rescue ex : IO::Error
            self.close
            Log.debug { "Got IO::Error in TCPSocket::read: \"#{ex.to_s}\"" }
            return
          end

          # Server has closed the connnection
          if bytes_read == 0
            self.close
            raise ConnectionClosed.new("Connection was closed by the server (bytes_read == 0)")
          end

          temp = temp[0, bytes_read]

          # Decrypt message with shared secret if encryption is enabled
          @encryption.try do |encryption|
            temp = Crypt.decrypt(
              cipher: encryption[:decryptor],
              data: temp
            )
          end

          buffer += temp

          # Determine how much of a packet we have received
          length = PacketBuffer.new(buffer).read_var_int
          length_size = PacketBuffer.var_int_size(length)
          remaining = length - (buffer.size - length_size) # length header value does not include length itself (but buffer itself does, so subtract it)

          # Complete; Received packet length matches length header
          if remaining == 0
            self.handle(@state, buffer)
            break
            # Incomplete; Received packet is smaller than length header
          elsif remaining > 0
            next
            # Excess; Received packet contains whole packet with excess data
          else
            bytes_available = length_size + length
            formed = buffer[0, bytes_available]
            buffer = buffer[bytes_available..]
            self.handle(@state, formed)
            next
          end
        end
      end
    end
  end

  def connect(host : String, port : Int32 = 25565)
    # Authenticate unless already done so, or offline mode
    self.authenticate unless @authentication || @password.nil?

    # Resolve the DNS
    begin
      records = DNS.query("_minecraft._tcp." + host, [DNS::RecordType::SRV])

      # Use the first resolved record
      records.each do |record|
        if record.record_type.srv?
          srv_resource = record.resource.as(DNS::Resource::SRV)
          host = srv_resource.target
          port = srv_resource.port
          Log.debug { "SRV lookup: #{host}:#{port}" }
          break
        end
      end
    rescue err
      Log.debug { "DNS resolution failed: #{err}" }
    end

    # Establish TCP socket connection with server
    @socket = TCPSocket.new(host, port)

    # Set the protocol state to handshaking
    @state = ProtocolState::Handshaking

    # Start login sequence
    handshake = Handshaking::S::Handshake.new(PROTOCOL_VERSION, host, port.to_i16, 2)
    self.write(handshake)

    login_start = Login::S::LoginStart.new(@username.not_nil!)
    self.write(login_start)

    @state = ProtocolState::Login

    # Start receiving packets
    self.read
  end

  def disconnect
    self.close
  end

  def close
    @encryption = nil
    @parser.compression = -1 # nil

    # Attempt to close the socket
    @socket.try &.close

    # Reset the socket
    @socket = nil
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
  # Packet handlers (login sequence and keep alive)
  #

  def handle(packet : Login::C::EncryptionRequest)
    # Generate a shared secret
    shared_secret = Crypt.generate_shared_secret

    # Convert ASN.1 DER encoded bytes to PEM
    pem = String.build do |str|
      str << "-----BEGIN PUBLIC KEY-----\n"
      str << Base64.encode(packet.public_key)
      str << "-----END PUBLIC KEY-----"
    end

    # Import PEM key to RSA
    rsa_key = OpenSSL::PKey::RSA.new(pem)

    # Encrypt the shared secret and verify token using public key (PKCS#1 v1.5 padded)
    shared_secret_encrypted = rsa_key.public_encrypt(shared_secret, LibCrypto::Padding::PKCS1_PADDING)
    verify_token_encrypted = rsa_key.public_encrypt(packet.verify_token, LibCrypto::Padding::PKCS1_PADDING)

    # Authenticate with the server
    @authentication.try do |authentication|
      server_hash = Crypt.generate_server_hash(packet.server_id, shared_secret, packet.public_key)
      Authenticator.server_auth(authentication[:uuid], authentication[:access_token], server_hash)
    end

    # Send the encrypted data to the server
    encryption_response = Login::S::EncryptionResponse.new(
      shared_secret_length: shared_secret_encrypted.size,
      shared_secret: shared_secret_encrypted,
      verify_token_length: verify_token_encrypted.size,
      verify_token: verify_token_encrypted,
    )

    self.write(encryption_response)

    # Enable encryption
    Log.debug { "Encryption enabled by server" }
    @encryption = {
      shared_secret: shared_secret,
      encryptor:     Crypt.encryptor("aes-128-cfb8", shared_secret),
      decryptor:     Crypt.decryptor("aes-128-cfb8", shared_secret),
    }
  end

  def handle(packet : Login::C::LoginDisconnect)
    @socket.try(&.close)
    raise LoginDisconnect.new("Unable to join server (Reason: \"#{packet.reason}\")")
  end

  def handle(packet : Login::C::LoginSuccess)
    Log.debug { "Login Success received; Setting Protocol State to \"Play\"" }
    @state = ProtocolState::Play
  end

  def handle(packet : Login::C::EnableCompression)
    Log.debug { "Compression set to #{packet.threshold}" }
    @parser.compression = packet.threshold
  end

  def handle(packet : Play::C::KeepAlive)
    keep_alive = Play::S::KeepAlive.new(packet.keep_alive_id)
    self.write(keep_alive)
  end

  def handle(packet : Play::C::PlayDisconnect)
    @socket.try(&.close)
    raise PlayDisconnect.new("Kicked from server (Reason: \"#{packet.reason}\")")
  end
end
