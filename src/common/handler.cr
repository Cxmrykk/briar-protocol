require "./events"
require "./packets"
require "./parser"

define_event_manager([
  {Handshake, handshake, {Int32, String, Int16, Int32}},
])

#
# Formats received packets into structured data
#

class PacketHandler < EventManager
  def initialize
    @parser = PacketParser.new
  end

  def set_compression(compression : Int32?)
    @parser.compression = compression
  end

  #
  # Defines control expressions for triggering events
  #

  macro handle_client_bound_event(state, packet, list)
    case {{state}}
    {% for current_state in list %}
      when {{current_state[0]}}
        {% for data in current_state[1] %}
        case {{packet}}.id
          when {{data[2]}}
            {{data[1]}} = {{data[0]}}.new({{packet}})
            self.send(:{{data[1]}}, {{data[1]}}.to_tuple)
        {% end %}
        end
    {% end %}
    end
  end

  #
  # Parses a buffer into RawPacket, triggers an event based on it.
  # Todo: overload with macro for packet types (defined in packets.cr)
  #

  def receive_client_bound(state : ProtocolState, data : Bytes)
    packet = @parser.parse(data)
    handle_client_bound_event(state, packet, [
      {Handshaking, [
        {Handshake, handshake, 0x00},
      ]},
      {Status, [
        {ServerInfo, server_info, 0x00},
        {Pong, pong, 0x01},
      ]},
      {Login, [
        {Disconnect, disconnect, 0x00},
        {EncryptionRequest, encryption_request, 0x01},
        {LoginSuccess, login_success, 0x02},
        {EnableCompression, enable_compression, 0x03},
      ]},
      {Play, [
        {KeepAlive, keep_alive, 0x00},
        {JoinGame, join_game, 0x01},
        {Chat, chat, 0x02},
        {TimeUpdate, time_update, 0x03},
        {EntityEquipment, entity_equipment, 0x04},
        {SpawnPosition, spawn_position, 0x05},
        {UpdateHealth, update_health, 0x06},
        {Respawn, respawn, 0x07},
        {PlayerPosLook, player_pos_look, 0x08},
        {HeldItemChange, held_item_change, 0x09},
        {UseBed, use_bed, 0x0A},
        {Animation, animation, 0x0B},
        {SpawnPlayer, spawn_player, 0x0C},
        {CollectItem, collect_item, 0x0D},
        {SpawnObject, spawn_object, 0x0E},
        {SpawnMob, spawn_mob, 0x0F},
        {SpawnPainting, spawn_painting, 0x10},
        {SpawnExperienceOrb, spawn_experience_orb, 0x11},
        {EntityVelocity, entity_velocity, 0x12},
        {DestroyEntities, destroy_entities, 0x13},
        {Entity, entity, 0x14},
        {EntityRelativeMove, entity_relative_move, 0x15},
        {EntityLook, entity_look, 0x16},
        {EntityLookAndRelativeMove, entity_look_and_relative_move, 0x17},
        {EntityTeleport, entity_teleport, 0x18},
        {EntityHeadLook, entity_head_look, 0x19},
        {EntityStatus, entity_status, 0x1A},
        {AttachEntity, attach_entity, 0x1B},
        {EntityMetadata, entity_metadata, 0x1C},
        {EntityEffect, entity_effect, 0x1D},
        {RemoveEntityEffect, remove_entity_effect, 0x1E},
        {SetExperience, set_experience, 0x1F},
        {EntityProperties, entity_properties, 0x20},
        {ChunkData, chunk_data, 0x21},
        {MultiBlockChange, multi_block_change, 0x22},
        {BlockChange, block_change, 0x23},
        {BlockAction, block_action, 0x24},
        {BlockBreakAnim, block_break_anim, 0x25},
        {MapChunkBulk, map_chunk_bulk, 0x26},
        {Explosion, explosion, 0x27},
        {Effect, effect, 0x28},
        {SoundEffect, sound_effect, 0x29},
        {Particles, particles, 0x2A},
        {ChangeGameState, change_game_state, 0x2B},
        {SpawnGlobalEntity, spawn_global_entity, 0x2C},
        {OpenWindow, open_window, 0x2D},
        {CloseWindow, close_window, 0x2E},
        {SetSlot, set_slot, 0x2F},
        {WindowItems, window_items, 0x30},
        {WindowProperty, window_property, 0x31},
        {ConfirmTransaction, confirm_transaction, 0x32},
        {UpdateSign, update_sign, 0x33},
        {Maps, maps, 0x34},
        {UpdateTileEntity, update_tile_entity, 0x35},
        {SignEditorOpen, sign_editor_open, 0x36},
        {Statistics, statistics, 0x37},
        {PlayerListItem, player_list_item, 0x38},
        {PlayerAbilities, player_abilities, 0x39},
        {TabComplete, tab_complete, 0x3A},
        {ScoreboardObjective, scoreboard_objective, 0x3B},
        {UpdateScore, update_score, 0x3C},
        {DisplayScoreboard, display_scoreboard, 0x3D},
        {Teams, teams, 0x3E},
        {CustomPayload, custom_payload, 0x3F},
        {Disconnect, disconnect, 0x40},
        {ServerDifficulty, server_difficulty, 0x41},
        {CombatEvent, combat_event, 0x42},
        {Camera, camera, 0x43},
        {WorldBorder, world_border, 0x44},
        {Title, title, 0x45},
        {SetCompressionLevel, set_compression_level, 0x46},
        {PlayerListHeaderFooter, player_list_header_footer, 0x47},
        {ResourcePackSend, resource_pack_send, 0x48},
        {UpdateEntityNBT, update_entity_nbt, 0x49},
      ]},
    ])
  end
end

#
# TODO: Receive server bound packets (implemented with server class)
#
