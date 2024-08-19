require "big"
require "./types"

class PacketBuffer
  getter data : Bytes
  getter offset : Int32

  setter data : Bytes
  setter offset : Int32

  def self.var_int_size(value : Int32) : Int32
    size = 0
    value = value.unsafe_as(UInt32)
    while true
      size += 1
      value >>= 7
      break if value == 0
    end
    size
  end

  def initialize(@data : Bytes = Bytes.new(0))
    @offset = 0
  end

  def read_var_int : Int32
    value = 0_u32
    shift = 0

    loop do
      temp = read_byte.to_u32
      value |= (temp & 0x7F) << shift
      shift += 7

      break if (temp & 0x80) == 0
      raise "VarInt is too big" if shift >= 35
    end

    value.unsafe_as(Int32)
  end

  def write_var_int(value : Int32)
    value = value.unsafe_as(UInt32)

    loop do
      temp = value & 0x7F
      value >>= 7

      if value != 0
        temp |= 0x80
      end

      write_byte(temp.to_u8)
      break if value == 0
    end
  end

  def write_var_long(value : Int64)
    value = value.unsafe_as(UInt64)

    loop do
      temp = value & 0x7F_u64
      value >>= 7

      if value != 0
        temp |= 0x80_u64
      end

      write_byte(temp.to_u8)
      break if value == 0
    end
  end

  def read_var_long : Int64
    value = 0_u64
    shift = 0

    loop do
      temp = read_byte.to_u64
      value |= (temp & 0x7F) << shift
      shift += 7

      break if (temp & 0x80) == 0
      raise "VarLong is too big" if shift >= 70
    end

    value.unsafe_as(Int64)
  end

  def read_string : String
    length = read_var_int
    string = String.new(@data[@offset, length])
    @offset += length
    string
  end

  def write_string(string : String)
    bytes = string.to_slice
    write_var_int(bytes.size)
    @data = Bytes.new(@data.size + bytes.size) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += bytes.size
  end

  def read_byte : UInt8
    @data[@offset].tap { @offset += 1 }
  end

  def write_byte(byte : UInt8)
    @data = Bytes.new(@data.size + 1) do |i|
      i < @data.size ? @data[i] : byte
    end
    @offset += 1
  end

  def read_short : Int16
    value = IO::ByteFormat::BigEndian.decode(Int16, @data[@offset, 2])
    @offset += 2
    value
  end

  def write_short(short : Int16)
    bytes = Bytes.new(2)
    IO::ByteFormat::BigEndian.encode(short, bytes)
    @data = Bytes.new(@data.size + 2) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += 2
  end

  def read_unsigned_short : UInt16
    value = IO::ByteFormat::BigEndian.decode(UInt16, @data[@offset, 2])
    @offset += 2
    value
  end

  def write_unsigned_short(short : UInt16)
    bytes = Bytes.new(2)
    IO::ByteFormat::BigEndian.encode(short, bytes)
    @data = Bytes.new(@data.size + 2) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += 2
  end

  def read_int : Int32
    value = IO::ByteFormat::BigEndian.decode(Int32, @data[@offset, 4])
    @offset += 4
    value
  end

  def write_int(int : Int32)
    bytes = Bytes.new(4)
    IO::ByteFormat::BigEndian.encode(int, bytes)
    @data = Bytes.new(@data.size + 4) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += 4
  end

  def read_long : Int64
    value = IO::ByteFormat::BigEndian.decode(Int64, @data[@offset, 8])
    @offset += 8
    value
  end

  def write_long(long : Int64)
    bytes = Bytes.new(8)
    IO::ByteFormat::BigEndian.encode(long, bytes)
    @data = Bytes.new(@data.size + 8) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += 8
  end

  def read_float : Float32
    value = IO::ByteFormat::BigEndian.decode(Float32, @data[@offset, 4])
    @offset += 4
    value
  end

  def write_float(float : Float32)
    bytes = Bytes.new(4)
    IO::ByteFormat::BigEndian.encode(float, bytes)
    @data = Bytes.new(@data.size + 4) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += 4
  end

  def read_double : Float64
    value = IO::ByteFormat::BigEndian.decode(Float64, @data[@offset, 8])
    @offset += 8
    value
  end

  def write_double(double : Float64)
    bytes = Bytes.new(8)
    IO::ByteFormat::BigEndian.encode(double, bytes)
    @data = Bytes.new(@data.size + 8) do |i|
      i < @data.size ? @data[i] : bytes[i - @data.size]
    end
    @offset += 8
  end

  def read_boolean : Bool
    read_byte != 0
  end

  def write_boolean(boolean : Bool)
    write_byte(boolean ? 1_u8 : 0_u8)
  end

  def read_byte_array(length : Int32) : Bytes
    array = @data[@offset, length]
    @offset += length
    array
  end

  def write_byte_array(array : Bytes)
    @data = Bytes.new(@data.size + array.size) do |i|
      i < @data.size ? @data[i] : array[i - @data.size]
    end
    @offset += array.size
  end

  def read_position : Position
    Position.from_long(read_long)
  end

  def write_position(position : Position)
    write_long(position.to_long)
  end

  def read_angle : Angle
    Angle.new(read_byte, read_byte)
  end

  def write_angle(angle : Angle)
    write_byte(angle.pitch)
    write_byte(angle.yaw)
  end

  # ... other read/write methods for different data types ...
end
