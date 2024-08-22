require "./types"
require "./macros"
require "../buffer"

module Packets
  include Types

  alias Meta = Metadata::Data

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
        {item, Slot?, slot},
      ])

      define_packet(SpawnPosition, 0x05, [
        {location, Position, position},
      ])

      define_packet(UpdateHealth, 0x06, [
        {health, Float32, float},
        {food, Int32, var_int},
        {food_saturation, Float32, float},
      ])

      define_packet(Respawn, 0x07, [
        {dimension, Int32, int},
        {difficulty, UInt8, unsigned_byte},
        {gamemode, UInt8, unsigned_byte},
        {level_type, String, string},
      ])

      define_packet(PlayerPosLook, 0x08, [
        {x, Float64, double},
        {y, Float64, double},
        {z, Float64, double},
        {yaw, Float32, float},
        {pitch, Float32, float},
        {flags, Int8, signed_byte},
      ])

      define_packet(HeldItemChange, 0x09, [
        {slot, Int8, signed_byte},
      ])

      define_packet(UseBed, 0x0A, [
        {entity_id, Int32, var_int},
        {location, Position, position},
      ])

      define_packet(Animation, 0x0B, [
        {entity_id, Int32, var_int},
        {animation, UInt8, unsigned_byte},
      ])

      define_packet(SpawnPlayer, 0x0C, [
        {entity_id, Int32, var_int},
        {player_uuid, UUID, uuid},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
        {yaw, Angle, angle},
        {pitch, Angle, angle},
        {current_item, Int16, short},
        {metadata, Meta, metadata}
      ])
      
      define_packet(CollectItem, 0x0D, [
        {collected_entity_id, Int32, var_int},
        {collector_entity_id, Int32, var_int}
      ])

      define_packet(SpawnObject, 0x0E, [
        {entity_id, Int32, var_int},
        {type, Int8, signed_byte},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
        {pitch, Angle, angle},
        {yaw, Angle, angle},
        {object_data, Int32, int},
        {velocity_x, Int16?, short, @object_data != 0},
        {velocity_y, Int16?, short, @object_data != 0},
        {velocity_z, Int16?, short, @object_data != 0}
      ])

      define_packet(SpawnMob, 0x0F, [
        {entity_id, Int32, var_int},
        {type, UInt8, unsigned_byte},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
        {yaw, Angle, angle},
        {pitch, Angle, angle},
        {head_pitch, Angle, angle},
        {velocity_x, Int16, short},
        {velocity_y, Int16, short},
        {velocity_z, Int16, short},
        {metadata, Meta, metadata}
      ])

      define_packet(SpawnPainting, 0x10, [
        {entity_id, Int32, var_int},
        {title, String, string}, # TODO: Max length 13
        {location, Position, position},
        {direction, UInt8, unsigned_byte}
      ])

      define_packet(SpawnExperienceOrb, 0x11, [
        {entity_id, Int32, var_int},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
        {count, Int16, short}
      ])

      define_packet(EntityVelocity, 0x12, [
        {entity_id, Int32, var_int},
        {velocity_x, Int16, short},
        {velocity_y, Int16, short},
        {velocity_z, Int16, short}
      ])

      #define_packet(DestroyEntities, 0x13, [
      #  {count, Int32, var_int},
      #  {entity_ids, Array(Int32), array(var_int)}
      #])

      #
      # TODO: fully implement arrays
      # 

    end

    module S
      define_packet(KeepAlive, 0x00, [
        {keep_alive_id, Int32, var_int},
      ])
    end
  end
end
