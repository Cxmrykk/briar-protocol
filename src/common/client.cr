require "socket"
require "log"

require "./event"
require "./handler"
require "../packets"
require "../buffer"

BUFFER_SIZE = 1024 * 1024

class Client < ClientHandler
  include Packets

  @socket : TCPSocket?
  @state : ProtocolState

  def initialize(@username : String, @password : String? = nil)
    super()
    @state = ProtocolState::Handshaking
  end

  def get_length_header(data : Bytes)
    PacketBuffer.new(data).read_var_int
  end

  def write(packet : RawPacket)
    return unless socket = @socket
    return if socket.closed?
    data = @parser.format(packet)
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

        buffer += temp[0, bytes_read]

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
