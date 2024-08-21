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
      temp = read_unsigned_byte.to_u32
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

      write_unsigned_byte(temp.to_u8)
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

      write_unsigned_byte(temp.to_u8)
      break if value == 0
    end
  end

  def read_var_long : Int64
    value = 0_u64
    shift = 0

    loop do
      temp = read_unsigned_byte.to_u64
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

  def read_unsigned_byte : UInt8
    @data[@offset].tap { @offset += 1 }
  end

  def write_unsigned_byte(byte : UInt8)
    @data = Bytes.new(@data.size + 1) do |i|
      i < @data.size ? @data[i] : byte
    end
    @offset += 1
  end

  def read_signed_byte : Int8
    read_unsigned_byte.unsafe_as(Int8)
  end

  def write_signed_byte(byte : Int8)
    byte = byte.unsafe_as(UInt8)
    write_unsigned_byte(byte)
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
    read_unsigned_byte != 0
  end

  def write_boolean(boolean : Bool)
    write_unsigned_byte(boolean ? 1_u8 : 0_u8)
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

  #
  # NBT Functions
  # 

  def read_nbt(type : Int8? = nil) : Nbt::Value?
    if type.nil?
      read_named_tag
    else
      read_tag(type)
    end
  end

  private def read_named_tag : Nbt::NamedTag?
    id = read_signed_byte

    if id == 0
      return nil
    end

    name = read_modified_utf8_string
    value = read_tag(id)
    return nil if value.nil?
    {name: name, value: value}
  end

  private def read_tag(id : Int8) : Nbt::Tag?
    case Nbt::ID.new(id)
    when .end?
      nil
    when .byte?
      read_signed_byte
    when .short?
      read_short
    when .int?
      read_int
    when .long?
      read_long
    when .float?
      read_float
    when .double?
      read_double
    when .byte_array?
      read_byte_array(read_int)
    when .string?
      read_modified_utf8_string
    when .list?
      read_list
    when .compound?
      read_compound
    when .int_array?
      read_int_array
    else
      raise "Unknown NBT tag ID: #{id}"
    end
  end

  private def read_list : Array(Nbt::Tag)
    id = read_signed_byte
    length = read_int
    (0...length).map do
      value = read_tag(id)
      raise "Parsing NBT TagList: Got TagEnd when Tag ID #{id} was expected" if value.nil?
      value.as(Nbt::Tag)
    end
  end

  private def read_compound : Hash(String, Nbt::Tag)
    result = Hash(String, Nbt::Tag).new
    while (tag = read_named_tag)
      result[tag[:name]] = tag[:value]
    end
    result
  end

  private def read_int_array : Array(Int32)
    length = read_int
    (0...length).map { read_int }
  end

  def read_slot : Slot?
    id = read_short

    if id < 0
      nil if id == -1
      raise "Slot ID provided was less than -1 (got #{id})"
    end

    item_count = read_signed_byte
    item_damage = read_short
    nbt = read_nbt
    Slot.new(id, item_count, item_damage, nbt)
  end

  private def read_modified_utf8_string : String
    length = read_short
    result = String.build do |str|
      end_offset = @offset + length
      while @offset < end_offset
        byte1 = @data[@offset].to_u8
        @offset += 1
  
        if byte1 & 0x80 == 0  # 1-byte format
          str << byte1.chr unless byte1 == 0
        elsif byte1 & 0xE0 == 0xC0  # 2-byte format
          byte2 = @data[@offset].to_u8
          @offset += 1
          
          codepoint = ((byte1 & 0x1F) << 6) | (byte2 & 0x3F)
          str << codepoint.chr
        elsif byte1 & 0xF0 == 0xE0  # 3-byte format
          byte2 = @data[@offset].to_u8
          byte3 = @data[@offset + 1].to_u8
          @offset += 2
          
          codepoint = ((byte1 & 0x0F) << 12) | ((byte2 & 0x3F) << 6) | (byte3 & 0x3F)
          str << codepoint.chr
        else
          raise "Invalid Modified UTF-8 encoding"
        end
      end
    end
    
    result
  end

  # ... other read/write methods for different data types ...
end
