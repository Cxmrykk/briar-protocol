require "log"
require "compress/zlib"

require "../../buffer"
require "../../packets"

alias RawPacket = Packets::RawPacket

struct PacketParser
  def initialize
    @compression = nil
  end

  def compression=(compression : Int32)
    if compression < 0
      @compression = nil
    else
      @compression = compression
    end
  end

  def parse(data : Bytes) : RawPacket?
    if @compression
      packet = Compressed.new(data, @compression.not_nil!)
      packet.to_raw
    else
      packet = Uncompressed.new(data)
      packet.to_raw
    end
  rescue ex : Compress::Deflate::Error
    Log.error { "Unable to deflate packet" }
    RawPacket.new(-1, Bytes.empty)
  end

  def format(packet : RawPacket) : Bytes
    # Compression has been set
    if @compression
      data = packet.slice
      data_length = data.size

      # Send as uncompressed packet, in compressed packet format
      if data_length < @compression.not_nil!
        # If Data Length is set to zero, then the packet is uncompressed
        length = PacketBuffer.var_int_size(0) + data.size

        # Format the final packet buffer
        buffer = PacketBuffer.new
        buffer.write_var_int(length)
        buffer.write_var_int(0)
        buffer.write_byte_array(data)
        buffer.data

        # Compress the packet before sending
      else
        compressed_data = IO::Memory.new.tap { |io| Compress::Zlib::Writer.open(io, &.write(data)) }.to_slice
        length = PacketBuffer.var_int_size(data_length) + compressed_data.size

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

  struct Compressed
    @length : Int32
    @data_length : Int32
    @id : Int32
    @data : Bytes

    def initialize(data : Bytes, compression : Int32)
      buffer = PacketBuffer.new(data)
      @length = buffer.read_var_int
      @data_length = buffer.read_var_int

      # Contents are uncompressed (ID + data)
      if @data_length == 0
        @id = buffer.read_var_int
        size = uncompressed_data_size(@length, @data_length, @id)
        @data = buffer.read_byte_array(size)
      else
        # Not supported! Should be 0 if below threshold.
        if @data_length < compression
          Log.warn { "Data length was lower than compression threshold" }
        end

        # Determine size of compressed data and read it
        size = compressed_data_size(@length, @data_length)
        compressed_data = buffer.read_byte_array(size)

        # Apply decompression and read the data
        id_and_data = zlib_to_bytes(compressed_data)
        buffer = PacketBuffer.new(id_and_data)

        # Read the packet ID
        @id = buffer.read_var_int

        # Calculate the remaining data size and read the bytes
        size = decompressed_data_size(@data_length, @id)
        @data = buffer.read_byte_array(size)
      end
    end

    def to_raw : RawPacket
      RawPacket.new(@id, @data)
    end

    private def zlib_to_bytes(compressed_data : Bytes) : Bytes
      io = IO::Memory.new(compressed_data)
      Compress::Zlib::Reader.open(io) do |zlib|
        decompressed = IO::Memory.new
        IO.copy(zlib, decompressed)
        decompressed.to_slice
      end
    end

    # Gets only the size of the uncompressed data
    private def uncompressed_data_size(length, data_length, id)
      length - PacketBuffer.var_int_size(data_length) - PacketBuffer.var_int_size(id)
    end

    # Gets the size of the compressed ID + data
    private def compressed_data_size(length, data_length)
      length - PacketBuffer.var_int_size(data_length)
    end

    # Gets only the size of the decompressed data
    private def decompressed_data_size(data_length, id)
      data_length - PacketBuffer.var_int_size(id)
    end
  end

  struct Uncompressed
    @length : Int32
    @id : Int32
    @data : Bytes

    def initialize(data : Bytes)
      buffer = PacketBuffer.new(data)
      @length = buffer.read_var_int
      @id = buffer.read_var_int

      size = data_size(@length, @id)
      @data = buffer.read_byte_array(size)
    end

    def to_raw : RawPacket
      RawPacket.new(@id, @data)
    end

    # Gets only the data size
    private def data_size(length, id)
      length - PacketBuffer.var_int_size(id)
    end
  end
end
