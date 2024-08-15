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
    x = (value.to_i64 >> 38).to_i32
    y = (value.to_i64 << 52 >> 52).to_i32
    z = (value.to_i64 << 26 >> 38).to_i32
    Position.new(x, y, z)
  end
end

struct Angle
  property pitch : UInt8
  property yaw : UInt8

  def initialize(@pitch, @yaw)
  end
end
