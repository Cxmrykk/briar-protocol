require "big"
require "uuid"
require "./types"
require "./macros"

struct PacketBuffer
  getter data : Bytes
  getter offset : Int32

  def initialize(@data : Bytes = Bytes.new(0))
    @offset = 0
  end

  #
  # External
  #

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

  #
  # Array Types (only for relevant packets)
  #

  define_array_functions(Int32, read_var_int, write_var_int)
  define_array_functions(UInt16, read_unsigned_short, write_unsigned_short)
  define_array_functions(UInt8, read_unsigned_byte, write_unsigned_byte)
  define_array_functions(String, read_string, write_string)
  define_array_functions(Slot, read_slot, write_slot)
  define_array_functions(Attribute::Modifier, read_modifier, write_modifier)
  define_array_functions(Attribute::Property, read_att_property, write_att_property)
  define_array_functions(Chunk::Meta, read_chunk_meta, write_chunk_meta)
  define_array_functions(BlockRecord, read_block_record, write_block_record)
  define_array_functions(ExplosionRecord, read_explosion_record, write_explosion_record)
  define_array_functions(MapIcon, read_map_icon, write_map_icon)
  define_array_functions(Statistic, read_statistic, write_statistic)
  define_array_functions(PlayerList::Property, read_pl_property, write_pl_property)
  define_array_functions(PlayerList::Value, read_player, write_player, action)

  #
  # Primitive Data Types
  #

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

  def read_remaining_bytes : Bytes
    array = @data[@offset, @data.size - @offset]
    @offset = @data.size
    array
  end

  #
  # Position
  #

  def read_position : Position
    Position.from_long(read_long)
  end

  def write_position(position : Position)
    write_long(position.to_long)
  end

  #
  # Angle
  # 

  def read_angle : Angle
    read_unsigned_byte
  end

  def write_angle(angle : Angle)
    write_unsigned_byte(angle)
  end

  #
  # UUID
  # 

  def read_uuid : UUID
    most_significant_bits = read_long
    least_significant_bits = read_long

    uuid_bytes = IO::Memory.new(16)
    uuid_bytes.write_bytes(most_significant_bits, IO::ByteFormat::BigEndian)
    uuid_bytes.write_bytes(least_significant_bits, IO::ByteFormat::BigEndian)

    UUID.new(uuid_bytes.to_slice)
  end

  def write_uuid(uuid : UUID)
    io = IO::Memory.new(uuid.bytes)
    write_long(io.read_bytes(Int64, IO::ByteFormat::BigEndian))
    write_long(io.read_bytes(Int64, IO::ByteFormat::BigEndian))
  end

  #
  # NBT and subtypes
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
    in .end?
      nil
    in .byte?
      read_signed_byte
    in .short?
      read_short
    in .int?
      read_int
    in .long?
      read_long
    in .float?
      read_float
    in .double?
      read_double
    in .byte_array?
      read_byte_array(read_int)
    in .string?
      read_modified_utf8_string
    in .list?
      read_list
    in .compound?
      read_compound
    in .int_array?
      read_int_array
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

  def read_slot : Slot
    id = read_short
    return nil if id == -1
    raise "Slot ID provided was less than -1 (got #{id})" if id < -1

    SlotValue.new(
      id: id,
      item_count: read_signed_byte,
      item_damage: read_short,
      nbt: read_nbt
    )
  end

  private def read_modified_utf8_string : String
    length = read_short
    result = String.build do |str|
      end_offset = @offset + length
      while @offset < end_offset
        byte1 = @data[@offset].to_u8
        @offset += 1

        if byte1 & 0x80 == 0 # 1-byte format
          str << byte1.chr unless byte1 == 0
        elsif byte1 & 0xE0 == 0xC0 # 2-byte format
          byte2 = @data[@offset].to_u8
          @offset += 1

          codepoint = ((byte1 & 0x1F) << 6) | (byte2 & 0x3F)
          str << codepoint.chr
        elsif byte1 & 0xF0 == 0xE0 # 3-byte format
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

  #
  # Entity Metadata and subtypes
  #

  def read_metadata : Metadata::Data
    entries = Array(Metadata::Entry).new

    loop do
      entry = read_watchable_object
      break if entry.nil?
      entries << entry
    end

    entries
  end

  private def read_watchable_object : Metadata::Entry?
    type_and_id = read_unsigned_byte

    if type_and_id == 127
      return nil
    end

    type = ((type_and_id & 0xE0) >> 5).to_i32
    id = (type_and_id & 0x1F).to_i32

    value = read_watchable_object_value(type)

    {
      type:  type,
      id:    id,
      value: value,
    }
  end

  private def read_watchable_object_value(type : Int32) : Metadata::Value
    case type
    when 0
      read_signed_byte
    when 1
      read_short
    when 2
      read_int
    when 3
      read_float
    when 4
      read_string
    when 5
      read_slot
    when 6
      read_position
    when 7
      {
        x: read_float,
        y: read_float,
        z: read_float,
      }
    else
      raise "Unknown watchable object type: #{type}"
    end
  end

  #
  # Attribute Modifiers and Properties
  #

  def read_modifier : Attribute::Modifier
    {
      uuid:      read_uuid,
      amount:    read_double,
      operation: read_signed_byte,
    }
  end

  def write_modifier(modifier : Attribute::Modifier)
    write_uuid(modifier[:uuid])
    write_double(modifier[:amount])
    write_signed_byte(modifier[:operation])
  end

  def read_att_property : Attribute::Property
    {
      key:            read_string,
      value:          read_double,
      modifier_count: (mc = read_var_int),
      modifiers:      read_modifier_array(mc),
    }
  end

  def write_att_property(property : Attribute::Property)
    write_string(property[:key])
    write_double(property[:value])
    write_var_int(property[:modifier_count])
    write_modifier_array(property[:modifiers])
  end

  #
  # Chunk Data and subtypes
  #

  def read_chunk_meta : Chunk::Meta
    {
      chunk_x:          read_int,
      chunk_z:          read_int,
      primary_bit_mask: read_unsigned_short,
    }
  end

  def read_chunk_array_from_meta(meta : Array(Chunk::Meta), sky_light_sent : Bool) : Array(Chunk::Column)
    meta.map do |chunk_meta|
      read_chunk(chunk_meta[:primary_bit_mask], sky_light_sent)
    end
  end

  def read_chunk(primary_bit_mask : UInt16, size_or_sky_light : Int32 | Bool) : Chunk::Column
    sky_light_sent = begin
      case size_or_sky_light
      in Int32
        is_sky_light_sent?(primary_bit_mask, size_or_sky_light)
      in Bool
        size_or_sky_light
      end
    end

    sections = (0...16).map_with_index do |section_y|
      if (primary_bit_mask & (1 << section_y)) != 0
        read_chunk_section(sky_light_sent)
      else
        nil
      end
    end

    {
      sections: sections,
      biomes:   read_byte_array(256),
    }
  end

  private def read_chunk_section(sky_light_sent : Bool) : Chunk::Section
    {
      blocks:      read_unsigned_short_array(4096),
      block_light: read_nibble_array,
      sky_light:   sky_light_sent ? read_nibble_array : nil,
    }
  end

  private def read_nibble_array : Chunk::NibbleArray
    bytes = read_byte_array(2048)
    Chunk::NibbleArray.new(bytes)
  end

  # Calculate expected size without sky light:
  # - Chunk data (8192 bytes) + Block light (2048 bytes) per set bit in primary_bit_mask
  # - Plus 256 bytes for biomes
  # If actual chunk_data_size is larger, it likely includes sky light (additional 2048 bytes per section)
  private def is_sky_light_sent?(primary_bit_mask : UInt16, chunk_data_size : Int32) : Bool
    expected_size = primary_bit_mask.popcount.to_i32 * (8192 + 2048) + 256
    chunk_data_size > expected_size
  end

  #
  # Block Record
  #

  def read_block_record : BlockRecord
    {
      horizontal_pos: read_unsigned_byte,
      y:              read_unsigned_byte,
      block_id:       read_var_int,
    }
  end

  #
  # Explosion Record
  #

  def read_explosion_record : ExplosionRecord
    {
      x_offset: read_signed_byte,
      y_offset: read_signed_byte,
      z_offset: read_signed_byte,
    }
  end

  #
  # Map Icon
  #

  def read_map_icon : MapIcon
    {
      icon_data: read_signed_byte,
      x:         read_signed_byte,
      z:         read_signed_byte,
    }
  end

  #
  # Statistic
  # 

  def read_statistic : Statistic
    {
      name:  read_string,
      value: read_var_int,
    }
  end

  #
  # Player List and subtypes
  #

  def read_player(action : Int32) : PlayerList::Value
    {
      uuid:   read_uuid,
      action: read_pl_action(action),
    }
  end

  private def read_pl_action(action : Int32) : PlayerList::Action
    case PlayerList::ID.new(action)
    in .add_player?
      {
        name:              read_string,
        property_count:    (pc = read_var_int),
        properties:        read_pl_property_array(pc),
        gamemode:          read_var_int,
        ping:              read_var_int,
        has_display_name?: (hdn = read_boolean),
        display_name:      hdn ? read_string : nil,
      }
    in .update_gamemode?
      {
        gamemode: read_var_int,
      }
    in .update_latency?
      {
        ping: read_var_int,
      }
    in .update_display_name?
      {
        has_display_name?: (hdn = read_boolean),
        display_name:      hdn ? read_string : nil,
      }
    in .remove_player?
      nil
    end
  end

  private def read_pl_property : PlayerList::Property
    {
      name:      read_string,
      value:     read_string,
      signed?:   (s = read_boolean),
      signature: s ? read_string : nil,
    }
  end

  #
  # World Border
  #

  def read_wb_action(action : Int32) : WorldBorder::Action
    case WorldBorder::ID.new(action)
    in .set_size?
      {
        radius: read_double,
      }
    in .lerp_size?
      {
        old_radius: read_double,
        new_radius: read_double,
        speed:      read_var_long,
      }
    in .set_center?
      {
        x: read_double,
        z: read_double,
      }
    in .initialize?
      {
        x:                  read_double,
        z:                  read_double,
        old_radius:         read_double,
        new_radius:         read_double,
        speed:              read_var_long,
        portal_tp_boundary: read_var_int,
        warning_time:       read_var_int,
        warning_blocks:     read_var_int,
      }
    in .set_warning_time?
      {
        warning_time: read_var_int,
      }
    in .set_warning_blocks?
      {
        warning_blocks: read_var_int,
      }
    end
  end

  #
  # Title
  #

  def read_title_action(action : Int32) : Title::Action
    case Title::ID.new(action)
    in .set_title?
      {text: read_string}
    in .set_subtitle?
      {text: read_string}
    in .set_times_display?
      {
        fade_in:  read_int,
        stay:     read_int,
        fade_out: read_int,
      }
    in .hide?
      nil
    in .reset?
      nil
    end
  end

  # ... other read/write methods for different data types ...
end
