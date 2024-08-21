require "./types"
require "./macros"
require "../buffer"

module Packets
  include Types

  module Handshaking
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
    module C
      define_packet(Pong, 0x01, [
        {payload, Int64, long},
      ])
    end
  end

  module Login
    module C
      define_packet(LoginSuccess, 0x02, [
        {uuid, String, string},
        {username, String, string},
      ])
      define_packet(EnableCompression, 0x03, [
        {threshold, Int32, var_int},
      ])
    end

    module S
      define_packet(LoginStart, 0x00, [
        {name, String, string},
      ])
    end
  end

  module Play
    module C
      define_packet(KeepAlive, 0x00, [
        {keep_alive_id, Int32, var_int},
      ])
      define_packet(JoinGame, 0x01, [
        {entity_id, Int32, int},
        {gamemode, UInt8, unsigned_byte},
        {dimension, Int8, signed_byte},
        {difficulty, UInt8, unsigned_byte},
        {max_players, UInt8, unsigned_byte},
        {level_type, String, string},
        {reduced_debug_info, Bool, boolean},
      ])
      define_packet(Chat, 0x02, [
        {json_data, String, string},
        {position, Int8, signed_byte},
      ])
      define_packet(TimeUpdate, 0x03, [
        {world_age, Int64, long},
        {time_of_day, Int64, long},
      ])
      define_packet(EntityEquipment, 0x04, [
        {entity_id, Int32, var_int},
        {slot, Int16, short},
        {item, Slot, slot},
      ])
      define_packet(SpawnPosition, 0x05, [
        {location, Position, position},
      ])
    end

    module S
      define_packet(KeepAlive, 0x00, [
        {keep_alive_id, Int32, var_int},
      ])
    end
  end
end
