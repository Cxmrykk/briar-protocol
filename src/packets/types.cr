require "../buffer"

# Protocol State (packet exchange sequence)
enum ProtocolState
  Handshaking
  Status
  Login
  Play
end

# Packet ID with associated data
class RawPacket
  getter id : Int32
  getter data : Bytes

  def initialize(@id : Int32, @data : Bytes)
  end

  def slice : Bytes
    buffer = PacketBuffer.new
    buffer.write_var_int(@id)
    buffer.write_byte_array(@data)
    buffer.data
  end
end
