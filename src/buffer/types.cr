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

alias MapIcon = NamedTuple(
  icon_data: Int8,
  x: Int8,
  z: Int8)

alias Statistic = NamedTuple(
  name: String,
  value: Int32)

module PlayerList
  module Action_
    alias Value = AddPlayer |
                  UpdateGamemode |
                  UpdateLatency |
                  UpdateDisplayName |
                  RemovePlayer

    alias Property = NamedTuple(
      name: String,
      value: String,
      signed?: Bool,
      signature: String?)

    alias AddPlayer = NamedTuple(
      name: String,
      property_count: Int32,
      properties: Array(Property),
      gamemode: Int32,
      ping: Int32,
      has_display_name?: Bool,
      display_name: String?)

    alias UpdateGamemode = NamedTuple(
      gamemode: Int32)

    alias UpdateLatency = NamedTuple(
      ping: Int32)

    alias UpdateDisplayName = NamedTuple(
      has_display_name?: Bool,
      display_name: String?)

    # No fields
    alias RemovePlayer = Nil
  end

  enum ID
    AddPlayer
    UpdateGamemode
    UpdateLatency
    UpdateDisplayName
    RemovePlayer
  end

  alias Action = Action_::Value
  alias Property = Action_::Property

  alias Value = NamedTuple(
    uuid: UUID,
    action: Action)
end

module WorldBorder
  module Action_
    alias Value = SetSize |
                  LerpSize |
                  SetCenter |
                  Initialize |
                  SetWarningTime |
                  SetWarningBlocks

    alias SetSize = NamedTuple(
      radius: Float64)

    alias LerpSize = NamedTuple(
      old_radius: Float64,
      new_radius: Float64,
      speed: Int64)

    alias SetCenter = NamedTuple(
      x: Float64,
      z: Float64)

    alias Initialize = NamedTuple(
      x: Float64,
      z: Float64,
      old_radius: Float64,
      new_radius: Float64,
      speed: Int64,
      portal_tp_boundary: Int32,
      warning_time: Int32,
      warning_blocks: Int32)

    alias SetWarningTime = NamedTuple(
      warning_time: Int32)

    alias SetWarningBlocks = NamedTuple(
      warning_blocks: Int32)
  end

  enum ID
    SetSize
    LerpSize
    SetCenter
    Initialize
    SetWarningTime
    SetWarningBlocks
  end

  alias Action = Action_::Value
end

module Title
  module Action_
    alias Value = SetTitle |
                  SetSubtitle |
                  SetTimesDisplay |
                  Hide |
                  Reset

    alias SetTitle = NamedTuple(text: String)

    alias SetSubtitle = NamedTuple(text: String)

    alias SetTimesDisplay = NamedTuple(
      fade_in: Int32,
      stay: Int32,
      fade_out: Int32)

    alias Hide = Nil

    alias Reset = Nil
  end

  enum ID
    SetTitle
    SetSubtitle
    SetTimesDisplay
    Hide
    Reset
  end

  alias Action = Action_::Value
end
