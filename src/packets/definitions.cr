require "./packets"
require "./macros"

module Packets
  module Handshake
    module S
      define_packet(Handshake, 0x00, [
        {protocol_version, Int32, var_int},
        {address, String, string},
        {port, Int16, short},
        {next_state, Int32, var_int},
      ])
    end
  end

  module Status
  end

  module Login
  end

  module Play
  end
end

#
# https://wiki.vg/Data_types_(v47)
#

macro types_reference
  boolean,
  byte,
  unsigned_byte,
  short,
  unsigned_short,
  int,
  long,
  float,
  double,
  string,
  chat,
  var_int,
  var_long,
  chunk,
  metadata,
  slot,
  nbt_tag,
  position,
  angle,
  uuid,
  optional, # generic
  array, # generic
  enum_, #generic,
  byte_array,
end
