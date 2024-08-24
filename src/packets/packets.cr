require "./types"
require "./macros"
require "../buffer"

#
# define_packet
#

module Packets
  include Types

  alias Meta = Metadata::Data
  alias Property = Attribute::Property

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
      define_packet(ServerInfo, 0x00, [
        {json_response, String, string},
      ])

      define_packet(Pong, 0x01, [
        {payload, Int64, long},
      ])
    end
  end

  module Login
    module C
      define_packet(LoginDisconnect, 0x00, [
        {reason, String, string},
      ])

      define_packet(EncryptionRequest, 0x01, [
        {server_id, String, string},
        {public_key_length, Int32, var_int},
        {public_key, Bytes, byte_array, @public_key_length >= 0, "@public_key_length", "raise \"EncryptionRequest: Public Key length must be 0 or higher.\""},
        {verify_token_length, Int32, var_int},
        {verify_token, Bytes, byte_array, @verify_token_length >= 0, "@verify_token_length", "raise \"EncryptionRequest: Verify Token length must be 0 or higher.\""},
      ])

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
        {metadata, Meta, metadata},
      ])

      define_packet(CollectItem, 0x0D, [
        {collected_entity_id, Int32, var_int},
        {collector_entity_id, Int32, var_int},
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
        {velocity_z, Int16?, short, @object_data != 0},
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
        {metadata, Meta, metadata},
      ])

      define_packet(SpawnPainting, 0x10, [
        {entity_id, Int32, var_int},
        {title, String, string}, # TODO: Max length 13
        {location, Position, position},
        {direction, UInt8, unsigned_byte},
      ])

      define_packet(SpawnExperienceOrb, 0x11, [
        {entity_id, Int32, var_int},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
        {count, Int16, short},
      ])

      define_packet(EntityVelocity, 0x12, [
        {entity_id, Int32, var_int},
        {velocity_x, Int16, short},
        {velocity_y, Int16, short},
        {velocity_z, Int16, short},
      ])

      define_packet(DestroyEntities, 0x13, [
        {count, Int32, var_int},
        {entity_ids, Array(Int32), var_int_array, @count >= 0, "@count", "raise \"DestroyEntities: 'count' must be 0 or higher.\""},
      ])

      define_packet(Entity, 0x14, [
        {entity_id, Int32, var_int},
      ])

      define_packet(EntityRelativeMove, 0x15, [
        {entity_id, Int32, var_int},
        {delta_x, Int8, signed_byte},
        {delta_y, Int8, signed_byte},
        {delta_z, Int8, signed_byte},
        {on_ground, Bool, boolean},
      ])

      define_packet(EntityLook, 0x16, [
        {entity_id, Int32, var_int},
        {yaw, Angle, angle},
        {pitch, Angle, angle},
        {on_ground, Bool, boolean},
      ])

      define_packet(EntityLookAndRelativeMove, 0x17, [
        {entity_id, Int32, var_int},
        {delta_x, Int8, signed_byte},
        {delta_y, Int8, signed_byte},
        {delta_z, Int8, signed_byte},
        {yaw, Angle, angle},
        {pitch, Angle, angle},
        {on_ground, Bool, boolean},
      ])

      define_packet(EntityTeleport, 0x18, [
        {entity_id, Int32, var_int},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
        {yaw, Angle, angle},
        {pitch, Angle, angle},
        {on_ground, Bool, boolean},
      ])

      define_packet(EntityHeadLook, 0x19, [
        {entity_id, Int32, var_int},
        {head_yaw, Angle, angle},
      ])

      define_packet(EntityStatus, 0x1A, [
        {entity_id, Int32, int},
        {entity_status, Int8, signed_byte},
      ])

      define_packet(AttachEntity, 0x1B, [
        {entity_id, Int32, int},
        {vehicle_id, Int32, int},
        {leash, Bool, boolean},
      ])

      define_packet(EntityMetadata, 0x1C, [
        {entity_id, Int32, var_int},
        {metadata, Meta, metadata},
      ])

      define_packet(EntityEffect, 0x1D, [
        {entity_id, Int32, var_int},
        {effect_id, Int8, signed_byte},
        {amplifier, Int8, signed_byte},
        {duration, Int32, var_int},
        {hide_particles, Bool, boolean},
      ])

      define_packet(RemoveEntityEffect, 0x1E, [
        {entity_id, Int32, var_int},
        {effect_id, Int8, signed_byte},
      ])

      define_packet(SetExperience, 0x1F, [
        {experience_bar, Float32, float},
        {level, Int32, var_int},
        {total_experience, Int32, var_int},
      ])
      
      define_packet(EntityProperties, 0x20, [
        {entity_id, Int32, var_int},
        {property_count, Int32, int},
        {properties, Array(Property), property_array, @property_count >= 0, "@property_count", "raise \"EntityProperties: 'property_count' must be 0 or higher.\""}
      ])
    end

    module S
      define_packet(KeepAlive, 0x00, [
        {keep_alive_id, Int32, var_int},
      ])
    end
  end
end
