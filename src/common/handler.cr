require "log"

require "./parser"
require "../packets"

# Define case structure for handling packets by ID
macro generate_packet_handler(list)
  case state
  {% for current_state in list %}
  when {{current_state[0]}}
    case packet.id
    {% for data in current_state[1] %}
    when {{data[2]}}
      {{data[1]}} = {{data[0]}}.new(packet)
      self.handle({{data[1]}})
    {% end %}
    else
      Log.warn { "Unknown packet ID: #{"0x%02x" % packet.id} (length: #{packet.data.size})" }
    end
  {% end %}
  end
end

macro generate_handler(definitions)
  {% handshaking_packets = definitions[0] %}
  {% status_packets = definitions[1] %}
  {% login_packets = definitions[2] %}
  {% play_packets = definitions[3] %}

  # Initialize the packet parser
  def initialize
    @parser = PacketParser.new
  end

  # Define the handler for raw packet data
  def handle(state : ProtocolState, data : Bytes)
    packet = @parser.parse(data)

    generate_packet_handler([
      {ProtocolState::Handshaking, {{handshaking_packets}}},
      {ProtocolState::Status, {{status_packets}}},
      {ProtocolState::Login, {{login_packets}}},
      {ProtocolState::Play, {{play_packets}}},
    ])
  end

  # Define packet handlers for each packet type
  {% for packets in definitions %}
    {% for packet in packets %}
      def handle(packet : {{packet[0]}})
      end
    {% end %}
  {% end %}
end

class ClientHandler
  include Packets

  # Generate the ClientHandler class
  generate_handler({
    # Handshaking packets
    [
      # no client-bound handshaking packets
] of TupleLiteral,

    # Status packets
    [
      {Status::C::ServerInfo, server_info, 0x00},
      {Status::C::Pong, pong, 0x01},
    ],

    # Login packets
    [
      {Login::C::LoginDisconnect, login_disconnect, 0x00},
      {Login::C::EncryptionRequest, encryption_request, 0x01},
      {Login::C::LoginSuccess, login_success, 0x02},
      {Login::C::EnableCompression, enable_compression, 0x03},
    ],

    # Play packets
    [
      {Play::C::KeepAlive, keep_alive, 0x00},
      {Play::C::JoinGame, join_game, 0x01},
      {Play::C::Chat, chat, 0x02},
      {Play::C::TimeUpdate, time_update, 0x03},
      {Play::C::EntityEquipment, entity_equipment, 0x04},
      {Play::C::SpawnPosition, spawn_position, 0x05},
      {Play::C::UpdateHealth, update_health, 0x06},
      {Play::C::Respawn, respawn, 0x07},
      {Play::C::PlayerPosLook, player_pos_look, 0x08},
      {Play::C::HeldItemChange, held_item_change, 0x09},
      {Play::C::UseBed, use_bed, 0x0A},
      {Play::C::Animation, animation, 0x0B},
      {Play::C::SpawnPlayer, spawn_player, 0x0C},
      {Play::C::CollectItem, collect_item, 0x0D},
      {Play::C::SpawnObject, spawn_object, 0x0E},
      {Play::C::SpawnMob, spawn_mob, 0x0F},
      {Play::C::SpawnPainting, spawn_painting, 0x10},
      {Play::C::SpawnExperienceOrb, spawn_experience_orb, 0x11},
      {Play::C::EntityVelocity, entity_velocity, 0x12},
      {Play::C::DestroyEntities, destroy_entities, 0x13},
      {Play::C::Entity, entity, 0x14},
      {Play::C::EntityRelativeMove, entity_relative_move, 0x15},
      {Play::C::EntityLook, entity_look, 0x16},
      {Play::C::EntityLookAndRelativeMove, entity_look_and_relative_move, 0x17},
      {Play::C::EntityTeleport, entity_teleport, 0x18},
      {Play::C::EntityHeadLook, entity_head_look, 0x19},
      {Play::C::EntityStatus, entity_status, 0x1A},
      {Play::C::AttachEntity, attach_entity, 0x1B},
      {Play::C::EntityMetadata, entity_metadata, 0x1C},
      {Play::C::EntityEffect, entity_effect, 0x1D},
      {Play::C::RemoveEntityEffect, remove_entity_effect, 0x1E},
      {Play::C::SetExperience, set_experience, 0x1F},
      {Play::C::EntityProperties, entity_properties, 0x20},
      # {Play::C::ChunkData, chunk_data, 0x21},
      # {Play::C::MultiBlockChange, multi_block_change, 0x22},
      # {Play::C::BlockChange, block_change, 0x23},
      # {Play::C::BlockAction, block_action, 0x24},
      # {Play::C::BlockBreakAnim, block_break_anim, 0x25},
      # {Play::C::MapChunkBulk, map_chunk_bulk, 0x26},
      # {Play::C::Explosion, explosion, 0x27},
      # {Play::C::Effect, effect, 0x28},
      # {Play::C::SoundEffect, sound_effect, 0x29},
      # {Play::C::Particles, particles, 0x2A},
      # {Play::C::ChangeGameState, change_game_state, 0x2B},
      # {Play::C::SpawnGlobalEntity, spawn_global_entity, 0x2C},
      # {Play::C::OpenWindow, open_window, 0x2D},
      # {Play::C::CloseWindow, close_window, 0x2E},
      # {Play::C::SetSlot, set_slot, 0x2F},
      # {Play::C::WindowItems, window_items, 0x30},
      # {Play::C::WindowProperty, window_property, 0x31},
      # {Play::C::ConfirmTransaction, confirm_transaction, 0x32},
      # {Play::C::UpdateSign, update_sign, 0x33},
      # {Play::C::Maps, maps, 0x34},
      # {Play::C::UpdateTileEntity, update_tile_entity, 0x35},
      # {Play::C::SignEditorOpen, sign_editor_open, 0x36},
      # {Play::C::Statistics, statistics, 0x37},
      # {Play::C::PlayerListItem, player_list_item, 0x38},
      # {Play::C::PlayerAbilities, player_abilities, 0x39},
      # {Play::C::TabComplete, tab_complete, 0x3A},
      # {Play::C::ScoreboardObjective, scoreboard_objective, 0x3B},
      # {Play::C::UpdateScore, update_score, 0x3C},
      # {Play::C::DisplayScoreboard, display_scoreboard, 0x3D},
      # {Play::C::Teams, teams, 0x3E},
      # {Play::C::CustomPayload, custom_payload, 0x3F},
      # {Play::C::PlayDisconnect, play_disconnect, 0x40},
      # {Play::C::ServerDifficulty, server_difficulty, 0x41},
      # {Play::C::CombatEvent, combat_event, 0x42},
      # {Play::C::Camera, camera, 0x43},
      # {Play::C::WorldBorder, world_border, 0x44},
      # {Play::C::Title, title, 0x45},
      # {Play::C::SetCompressionLevel, set_compression_level, 0x46},
      # {Play::C::PlayerListHeaderFooter, player_list_header_footer, 0x47},
      # {Play::C::ResourcePackSend, resource_pack_send, 0x48},
      # {Play::C::UpdateEntityNBT, update_entity_nbt, 0x49},
    ],
  })
end
