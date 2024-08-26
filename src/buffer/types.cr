require "big"

alias Angle = UInt8
alias Chat = String

struct Position
  property x : Int32
  property y : Int32
  property z : Int32

  def initialize(@x, @y, @z)
  end

  def to_long : Int64
    (((x & 0x3FFFFFF).to_i64 << 38) | ((y & 0xFFF).to_i64 << 26) | (z & 0x3FFFFFF).to_i64)
  end

  def self.from_long(value : Int64)
    # Allow shift operations to affect sign bit
    value = value.unsafe_as(UInt64)
    x = (value >> 38).unsafe_as(Int64).to_i32
    y = ((value >> 26) & 0xFFF).unsafe_as(Int64).to_i32
    z = (value & 0x3FFFFFF).unsafe_as(Int64).to_i32

    # Apply sign extension if the most significant bit of z is set
    if (z & 0x2000000) != 0
      z = z | -0x4000000
    end

    Position.new(x, y, z)
  end
end

alias SlotValue = NamedTuple(
  id: Int16,
  item_count: Int8,
  item_damage: Int16,
  nbt: Nbt::Value?)

alias Slot = Nil | SlotValue

module Nbt
  alias Tag = Nil |
              Int8 |
              Int16 |
              Int32 |
              Int64 |
              Float32 |
              Float64 |
              Bytes |
              String |
              Array(Tag) |
              Hash(String, Tag) |
              Array(Int32)

  alias NamedTag = NamedTuple(name: String, value: Tag)

  alias Value = Tag | NamedTag

  enum ID
    End
    Byte
    Short
    Int
    Long
    Float
    Double
    ByteArray
    String
    List
    Compound
    IntArray
  end
end

module Metadata
  alias Rotations = NamedTuple(x: Float32, y: Float32, z: Float32)

  alias Value = Int8 |
                Int16 |
                Int32 |
                Int64 |
                Float32 |
                Float64 |
                Bytes |
                String |
                Slot? |
                Position |
                Rotations

  alias Entry = NamedTuple(type: Int32, id: Int32, value: Value)

  alias Data = Array(Entry)
end

module Attribute
  alias Modifier = NamedTuple(
    uuid: UUID,
    amount: Float64,
    operation: Int8)

  alias Property = NamedTuple(
    key: String,
    value: Float64,
    modifier_count: Int32,
    modifiers: Array(Modifier))
end

module Chunk
  alias Column = NamedTuple(
    sections: Array(Section?),
    biomes: Bytes)

  alias Section = NamedTuple(
    blocks: Array(UInt16),
    block_light: NibbleArray,
    sky_light: NibbleArray?)

  alias Meta = NamedTuple(
    chunk_x: Int32,
    chunk_z: Int32,
    primary_bit_mask: UInt16)

  struct NibbleArray
    property data : Bytes

    def initialize(@data : Bytes)
    end

    # Returns a value ranging from 0-15 (4 bits)
    def [](index : Int32) : UInt8
      byte_index = index >> 1
      nibble_index = index & 1

      byte = @data[byte_index].to_u8

      if nibble_index == 0
        byte & 0x0F
      else
        (byte >> 4) & 0x0F
      end
    end
  end
end

alias BlockRecord = NamedTuple(
  horizontal_pos: UInt8,
  y: UInt8,
  block_id: Int32)

alias ExplosionRecord = NamedTuple(
  x_offset: Int8,
  y_offset: Int8,
  z_offset: Int8)
