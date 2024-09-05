require "openssl_ext"
require "openssl"
require "base64"
require "socket"
require "log"

require "./auth"
require "./disk"
require "./crypt"
require "./handler"
require "../packets"
require "../buffer"

BUFFER_SIZE = 1024 * 1024

class Client < ClientHandler
  include Packets

  alias Authentication = NamedTuple(
    access_token: String,
    uuid: String,
  )

  alias Encryption = NamedTuple(
    shared_secret: Bytes,
    encryptor: OpenSSL::Cipher,
    decryptor: OpenSSL::Cipher)

  @state : ProtocolState
  @socket : TCPSocket?
  @authentication : Authentication?
  @encryption : Encryption?

  def initialize(@username : String, password : String? = nil)
    super()
    @state = ProtocolState::Handshaking

    unless password.nil?
      # Get the refresh token from disk cache (if present)
      refresh_token = Disk.read_token?(@username, password)

      # Authenticate using MSA
      result = Authenticator.auth(@username, refresh_token)

      # Save the updated refresh token to disk cache
      Disk.write_token(@username, password, result[:refresh_token])

      # Use relevant data
      @username = result[:profile]["name"].as_s
      @authentication = {
        access_token: result[:access_token],
        uuid:         result[:profile]["id"].as_s,
      }
    end
  end

  def get_length_header(data : Bytes)
    PacketBuffer.new(data).read_var_int
  end

  def write(packet : RawPacket)
    return unless socket = @socket
    return if socket.closed?

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
    loop do
      socket = @socket
      break if socket.nil? || socket.closed?

      buffer = Bytes.empty

      # Continue reading truncated packets
      loop do
        temp = Bytes.new(BUFFER_SIZE)
        bytes_read = socket.read(temp)

        # Server has closed the connnection
        if bytes_read == 0
          Log.debug { "Connection was forcefully closed by server" }
          return
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
        length = get_length_header(buffer)
        length_size = PacketBuffer.var_int_size(length)
        remaining = length - (buffer.size - length_size) # length header value does not include length itself (but buffer itself does, so subtract it)

        # Received packet length matches length header
        if remaining == 0
          break
          # Received packet is smaller than length header;
          # Cancel handling and truncate the next packet
        elsif remaining > 0
          next
          # Received packet contains whole packet, and more;
          # Use the rest as the start of next packet
        else
          bytes_available = length_size + length
          formed = buffer[0, bytes_available]
          buffer = buffer[bytes_available..]
          self.handle(@state, formed)
          next
        end
      end

      self.handle(@state, buffer)
    end
  end

  def connect(host : String, port : Int32 = 25565)
    @socket = TCPSocket.new(host, port)

    # Start login sequence
    handshake = Handshaking::S::Handshake.new(47, host, port.to_i16, 2)
    self.write(handshake)

    login_start = Login::S::LoginStart.new(@username)
    self.write(login_start)

    @state = ProtocolState::Login

    # Start receiving packets
    self.read
  end

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
    Log.debug { "Received Login Disconnect (Reason: \"#{packet.reason}\")" }
    @socket.try(&.close)
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

  def close
    @socket.try &.close
  end
end
