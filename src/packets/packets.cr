require "./types"
require "./macros"

require "../buffer"

module Packets
  module Handshaking
    module S
      define_packet(Handshake, 0x00, [
        {protocol_version, Int32, var_int},
        {address, String, string},
        {port, Int16, short},
        {intent, Int32, var_int},
      ])
    end
  end

  module Status
    module C
    end

    module S
    end
  end

  module Login
    module C
      define_packet(EncryptionRequest, 0x01, [
        {server_id, String, string},
        {public_key_length, Int32, var_int},
        {public_key, Bytes, byte_array, @public_key_length >= 0, "@public_key_length", "raise \"EncryptionRequest: Public Key length was negative!\""},
        {verify_token_length, Int32, var_int},
        {verify_token, Bytes, byte_array, @verify_token_length >= 0, "@verify_token_length", "raise \"EncryptionRequest: Verify Token length was negative!\""},
      ])

      define_packet(LoginSuccess, 0x02, [
        {uuid, String, string},
        {username, String, string},
        {properties, Array(TextureProperty), texture_property_array_prefixed},
      ])

      define_packet(EnableCompression, 0x03, [
        {threshold, Int32, var_int},
      ])
    end

    module S
      define_packet(LoginStart, 0x00, [
        {name, String, string},
        {uuid, UUID, uuid},
      ])

      define_packet(EncryptionResponse, 0x01, [
        {shared_secret_length, Int32, var_int},
        {shared_secret, Bytes, byte_array, @shared_secret_length >= 0, "@shared_secret_length", "raise \"EncryptionResponse: Shared Secret length was negative!\""},
        {verify_token_length, Int32, var_int},
        {verify_token, Bytes, byte_array, @verify_token_length >= 0, "@verify_token_length", "raise \"EncryptionResponse: Verify Token length was negative!\""},
      ])

      define_packet(LoginAcknowledged, 0x03, [] of Record)
    end
  end

  module Configuration
    module C
      define_packet(PluginMessageCB, 0x01, [
        {channel, String, string},
        {data, Bytes, remaining_bytes},
      ])

      define_packet(FeatureFlags, 0x0C, [
        {features, Array(String), string_array_prefixed},
      ])

      define_packet(KnownPacksCB, 0x0E, [
        {known_packs, Array(KnownDataPack), known_data_pack_array_prefixed},
      ])

      define_packet(RegistryData, 0x0E, [
        {registry_id, String, string},
        {entries, Array(RegistryData), registry_data_array_prefixed},
      ])
    end

    module S
      define_packet(ClientInformation, 0x00, [
        {locale, String, string},
        {view_distance, Int8, signed_byte},
        {chat_mode, Int32, var_int},
        {chat_colors, Bool, boolean},
        {displayed_skin_parts, UInt8, unsigned_byte},
        {main_hand, Int32, var_int},
        {enable_text_filtering, Bool, boolean},
        {allow_server_listings, Bool, boolean},
        {particle_status, Int32, var_int},
      ])

      define_packet(PluginMessageSB, 0x02, [
        {channel, String, string},
        {data, Bytes, remaining_bytes},
      ])

      define_packet(KnownPacksSB, 0x07, [
        {known_packs, Array(KnownDataPack), known_data_pack_array_prefixed},
      ])
    end
  end

  module Play
    module C
    end

    module S
    end
  end
end
