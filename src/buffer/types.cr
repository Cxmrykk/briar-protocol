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

struct Angle
  property pitch : UInt8
  property yaw : UInt8

  def initialize(@pitch, @yaw)
  end
end

struct Slot
  property id : Int16
  property item_count : Int8
  property item_damage : Int16
  property nbt : Nbt::Value?

  def initialize(@id, @item_count, @item_damage, @nbt)
  end
end

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
