require "log"
require "compress/zlib"

require "./buffer"

# Not the job of Parser
#
# enum ProtocolState
# end

#
# RawPacket
# - Parsed/Formatted packet ready for buffer operatons
#
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

class PacketParser
  setter compression : Int32?

  def initialize
    @compression = nil
  end

  def decompress_zlib(compressed_bytes : Bytes) : Bytes
    io = IO::Memory.new(compressed_bytes)
    reader = Compress::Zlib::Reader.new(io)
    decompressed_bytes = Bytes.new(compressed_bytes.size) # Initial size, might need to grow
    total_read = 0

    loop do
      read_bytes = reader.read(decompressed_bytes.to_slice[total_read..])
      break if read_bytes == 0
      total_read += read_bytes
      if total_read == decompressed_bytes.size
        decompressed_bytes = decompressed_bytes + Bytes.new(compressed_bytes.size) # Double the size if needed
      end
    end

    decompressed_bytes[0...total_read]
  end

  def parse(data : Bytes) : RawPacket
    buffer = PacketBuffer.new(data)

    # Compression has been set
    if @compression
      length = buffer.read_var_int
      data_length = buffer.read_var_int

      # Packet data is uncompressed
      if data_length == 0
        packet_id = buffer.read_var_int
        data = buffer.read_to_end
        RawPacket.new(packet_id, data)

        # Packet data is compressed, but too small for compression threshold
      elsif data_length < @compression.not_nil!
        Log.warn { "WARNING: Compressed packet is too small and did not meet compression threshold (#{data_length} < #{@compression})" }
        RawPacket.new(-1, Bytes.empty)

        # Packet data is compressed
      else
        decompressed_bytes = decompress_zlib(buffer.read_to_end)
        buffer = PacketBuffer.new(decompressed_bytes)
        buffer = PacketBuffer.new(buffer.read_byte_array(data_length))
        packet_id = buffer.read_var_int
        data = buffer.read_to_end
        RawPacket.new(packet_id, data)
      end

      # Compression set packet hasn't been sent by server
    else
      length = buffer.read_var_int
      buffer = PacketBuffer.new(buffer.read_byte_array(length))
      packet_id = buffer.read_var_int
      data = buffer.read_to_end
      RawPacket.new(packet_id, data)
    end
  end

  def format(packet : RawPacket) : Bytes
    # Compression has been set
    if @compression
      data = packet.slice
      data_length = data.size

      # Send as uncompressed packet, in compressed packet format
      if data_length < @compression.not_nil!
        # Create a temporary buffer to calculate packet length
        buffer = PacketBuffer.new
        buffer.write_var_int(0) # If Data Length is set to zero, then the packet is uncompressed
        buffer.write_byte_array(data)
        length = buffer.data.size

        # Format the final packet buffer
        buffer = PacketBuffer.new
        buffer.write_var_int(length)
        buffer.write_var_int(0)
        buffer.write_byte_array(data)
        buffer.data

        # Compress the packet before sending
      else
        compressed_data = IO::Memory.new.tap { |io| Compress::Zlib::Writer.open(io, &.write(data)) }.to_slice

        # Create a temporary buffer to calculate packet length
        buffer = PacketBuffer.new
        buffer.write_var_int(data_length)
        buffer.write_byte_array(compressed_data)
        length = buffer.data.size

        # Format the final packet buffer
        buffer = PacketBuffer.new
        buffer.write_var_int(length)
        buffer.write_var_int(data_length)
        buffer.write_byte_array(compressed_data)
        buffer.data
      end

      # Compression set packet hasn't been sent by server
    else
      length = packet.slice.size

      # Write uncompressed packet to new buffer
      buffer = PacketBuffer.new
      buffer.write_var_int(length)
      buffer.write_var_int(packet.id)
      buffer.write_byte_array(packet.data)
      buffer.data
    end
  end
end
