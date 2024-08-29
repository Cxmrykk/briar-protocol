require "./types"
require "./macros"
require "../buffer"

#
# define_packet
#

module Packets
  include Types

  alias Meta = Metadata::Data
  alias Player = PlayerList::Value

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
        {item, Slot, slot},
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
        {properties, Array(Attribute::Property), att_property_array, @property_count >= 0, "@property_count", "raise \"EntityProperties: 'property_count' must be 0 or higher.\""},
      ])

      define_packet(ChunkData, 0x21, [
        {chunk_x, Int32, int},
        {chunk_z, Int32, int},
        {continuous, Bool, boolean},
        {primary_bit_mask, UInt16, unsigned_short},
        {size, Int32, var_int},
        {chunk_data, Chunk::Column, chunk, @size >= 0, "@primary_bit_mask, @size", "raise \"ChunkData: 'size' must be 0 or higher.\""},
      ])

      define_packet(MultiBlockChange, 0x22, [
        {chunk_x, Int32, int},
        {chunk_z, Int32, int},
        {record_count, Int32, var_int},
        {records, Array(BlockRecord), block_record_array, @record_count >= 0, "@record_count", "raise \"MultiBlockChange: 'record_count' must be 0 or higher.\""},
      ])

      define_packet(BlockChange, 0x23, [
        {location, Position, position},
        {block_id, Int32, var_int},
      ])

      define_packet(BlockAction, 0x24, [
        {location, Position, position},
        {byte_1, UInt8, unsigned_byte},
        {byte_2, UInt8, unsigned_byte},
        {block_type, Int32, var_int},
      ])

      define_packet(BlockBreakAnim, 0x25, [
        {entity_id, Int32, var_int},
        {location, Position, position},
        {destroy_stage, Int8, signed_byte},
      ])

      define_packet(MapChunkBulk, 0x26, [
        {sky_light_sent, Bool, boolean},
        {column_count, Int32, var_int},
        {chunk_meta, Array(Chunk::Meta), chunk_meta_array, @column_count >= 0, "@column_count", "raise \"MapChunkBulk: 'column_count' must be 0 or higher.\""},
        {chunk_data, Array(Chunk::Column), chunk_array_from_meta, true, "@chunk_meta, @sky_light_sent", "raise \"\""},
      ])

      define_packet(Explosion, 0x27, [
        {x, Float32, float},
        {y, Float32, float},
        {z, Float32, float},
        {radius, Float32, float},
        {record_count, Int32, int},
        {records, Array(ExplosionRecord), explosion_record_array, @record_count >= 0, "@record_count", "raise \"Explosion: 'record_count' must be 0 or higher.\""},
        {player_motion_x, Float32, float},
        {player_motion_y, Float32, float},
        {player_motion_z, Float32, float},
      ])

      define_packet(Effect, 0x28, [
        {effect_id, Int32, int},
        {location, Position, position},
        {effect_data, Int32, int},
        {disable_relative_volume, Bool, boolean},
      ])

      define_packet(SoundEffect, 0x29, [
        {sound_name, String, string},
        {effect_pos_x, Int32, int},
        {effect_pos_y, Int32, int},
        {effect_pos_z, Int32, int},
        {volume, Float32, float},
        {pitch, UInt8, unsigned_byte},
      ])

      define_packet(Particles, 0x2A, [
        {particle_id, Int32, int},
        {long_distance, Bool, boolean},
        {x, Float32, float},
        {y, Float32, float},
        {z, Float32, float},
        {x_offset, Float32, float},
        {y_offset, Float32, float},
        {z_offset, Float32, float},
        {particle_data, Float32, float},
        {particle_count, Int32, int},
        # Not implemented; Length is dependant on particle_id value
        # {particle_metadata, Array(Int32), var_int_array, ...}
      ])

      define_packet(ChangeGameState, 0x2B, [
        {reason, UInt8, unsigned_byte},
        {value, Float32, float},
      ])

      define_packet(SpawnGlobalEntity, 0x2C, [
        {entity_id, Int32, var_int},
        {entity_type, Int8, signed_byte},
        {x, Int32, int},
        {y, Int32, int},
        {z, Int32, int},
      ])

      define_packet(OpenWindow, 0x2D, [
        {window_id, UInt8, unsigned_byte},
        {window_type, String, string},
        {window_title, String, string},
        {slot_count, UInt8, unsigned_byte},
        {entity_id, Int32?, int, @window_type == "EntityHorse"},
      ])

      define_packet(CloseWindow, 0x2E, [
        {window_id, UInt8, unsigned_byte},
      ])

      define_packet(SetSlot, 0x2F, [
        {window_id, Int8, signed_byte},
        {slot, Int16, short},
        {slot_data, Slot, slot},
      ])

      define_packet(WindowItems, 0x30, [
        {window_id, UInt8, unsigned_byte},
        {count, Int16, short},
        {slot_data, Array(Slot), slot_array, @count >= 0, "@count", "raise \"WindowItems: 'count' must be 0 or higher.\""},
      ])

      define_packet(WindowProperty, 0x31, [
        {window_id, UInt8, unsigned_byte},
        {window_property, Int16, short},
        {value, Int16, short},
      ])

      define_packet(ConfirmTransaction, 0x32, [
        {window_id, Int8, signed_byte},
        {action_number, Int16, short},
        {accepted, Bool, boolean},
      ])

      define_packet(UpdateSign, 0x33, [
        {location, Position, position},
        {line_1, String, string},
        {line_2, String, string},
        {line_3, String, string},
        {line_4, String, string},
      ])

      define_packet(Maps, 0x34, [
        {item_damage, Int32, var_int}, # item_damage is the Map ID
        {scale, Int8, signed_byte},
        {icon_count, Int32, var_int},
        {icons, Array(MapIcon), map_icon_array, @icon_count >= 0, "@icon_count", "raise \"Maps: 'icon_count' must be 0 or higher.\""},
        {columns, Int8, signed_byte},
        {rows, Int8?, signed_byte, @columns > 0},
        {x, Int8?, signed_byte, @columns > 0},
        {z, Int8?, signed_byte, @columns > 0},
        {map_data_length, Int32?, var_int, @columns > 0},
        {map_data, Array(UInt8)?, unsigned_byte_array, @columns > 0, "@map_data_length.not_nil!"},
      ])

      define_packet(UpdateTileEntity, 0x35, [
        {location, Position, position},
        {action, UInt8, unsigned_byte},
        {nbt, Nbt::Value?, nbt},
      ])

      define_packet(SignEditorOpen, 0x36, [
        {location, Position, position},
      ])

      define_packet(Statistics, 0x37, [
        {count, Int32, var_int},
        {statistics, Array(Statistic), statistic_array, @count >= 0, "@count", "raise \"Statistics: 'count' must be 0 or higher.\""},
      ])

      define_packet(PlayerListItem, 0x38, [
        {action, Int32, var_int},
        {player_count, Int32, var_int},
        {players, Array(Player), player_array, @player_count >= 0, "@player_count, @action", "raise \"PlayerListItem: 'player_count' must be 0 or higher.\""},
      ])

      define_packet(PlayerAbilities, 0x39, [
        {flags, Int8, signed_byte},
        {flying_speed, Float32, float},
        {fov_modifier, Float32, float},
      ])

      define_packet(TabComplete, 0x3A, [
        {count, Int32, var_int},
        {matches, Array(String), string_array, @count >= 0, "@count", "raise \"TabComplete: 'count' must be 0 or higher.\""},
      ])

      define_packet(ScoreboardObjective, 0x3B, [
        {name, String, string},
        {mode, Int8, signed_byte},
        {value, String?, string, @mode == 0 || @mode == 2},
        {type, String?, string, @mode == 0 || @mode == 2},
      ])

      define_packet(UpdateScore, 0x3C, [
        {name, String, string},
        {action, Int8, signed_byte},
        {objective, String, string},
        {value, Int32?, var_int, @action != 1},
      ])

      define_packet(DisplayScoreboard, 0x3D, [
        {position, Int8, signed_byte},
        {name, String, string},
      ])

      define_packet(Teams, 0x3E, [
        {name, String, string},
        {mode, Int8, signed_byte},
        {display_name, String?, string, @mode == 0 || @mode == 2},
        {prefix, String?, string, @mode == 0 || @mode == 2},
        {suffix, String?, string, @mode == 0 || @mode == 2},
        {friendly_fire, Int8?, signed_byte, @mode == 0 || @mode == 2},
        {name_tag_visibility, String?, string, @mode == 0 || @mode == 2},
        {colour, Int8?, signed_byte, @mode == 0 || @mode == 2},
        {player_count, Int32?, var_int, @mode == 0 || @mode == 3 || @mode == 4},
        {players, Array(String)?, string_array, @mode == 0 || @mode == 3 || @mode == 4, "@player_count.not_nil!"},
      ])

      define_packet(CustomPayload, 0x3F, [
        {channel, String, string},
        {remaining_data, Bytes, remaining_bytes},
      ])

      define_packet(PlayDisconnect, 0x40, [
        {reason, String, string},
      ])

      define_packet(ServerDifficulty, 0x41, [
        {difficulty, UInt8, unsigned_byte},
      ])

      define_packet(CombatEvent, 0x42, [
        {event, Int32, var_int},
        {duration, Int32?, var_int, @event == 1},
        {player_id, Int32?, var_int, @event == 2},
        {entity_id, Int32?, int, @event == 1 || @event == 2},
        {message, String?, string, @event == 2},
      ])

      define_packet(Camera, 0x43, [
        {camera_id, Int32, var_int},
      ])

      define_packet(SetWorldBorder, 0x44, [
        {action_id, Int32, var_int},
        {action, WorldBorder::Action, wb_action, @action_id <= 5, "@action_id", "raise \"SetWorldBorder: 'action_id' must be between 0 and 5.\""},
      ])

      define_packet(SetTitle, 0x45, [
        {action_id, Int32, var_int},
        {action, Title::Action, title_action, @action_id <= 4, "@action_id", "raise \"SetTitle: 'action_id' must be between 0 and 4.\""},
      ])

      define_packet(SetCompressionLevel, 0x46, [
        {threshold, Int32, var_int},
      ])

      define_packet(PlayerListHeaderFooter, 0x47, [
        {header, String, string},
        {footer, String, string},
      ])

      define_packet(ResourcePackSend, 0x48, [
        {url, String, string},
        {hash, String, string},
      ])

      define_packet(UpdateEntityNBT, 0x49, [
        {entity_id, Int32, var_int},
        {tag, Nbt::Value?, nbt},
      ])
    end

    module S
      define_packet(KeepAlive, 0x00, [
        {keep_alive_id, Int32, var_int},
      ])
    end
  end
end
