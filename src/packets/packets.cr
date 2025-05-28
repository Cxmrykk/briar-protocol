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
        {server_id, String, string, @server_id <= 20, @server_id, "raise \"EncryptionRequest: 'server_id' was more than 20 chars!\""},
        {public_key_length, Int32, var_int},
        {public_key, Bytes, byte_array, @public_key_length >= 0, "@public_key_length", "raise \"EncryptionRequest: Public Key length was negative!\""},
        {verify_token_length, Int32, var_int},
        {verify_token, Bytes, byte_array, @verify_token_length >= 0, "@verify_token_length", "raise \"EncryptionRequest: Verify Token length was negative!\""},
      ])

      define_packet(LoginSuccess, 0x02, [
        {uuid, String, string},
        {username, String, string},
        {properties_length, Int32, var_int},
        {properties, Array(TextureProperty), texture_property_array, @properties_length <= 16, "@properties_length", "raise \"LoginSuccess: 'properties_length' was more than 16!\""},
      ])

      define_packet(EnableCompression, 0x03, [
        {threshold, Int32, var_int},
      ])
    end

    module S
      define_packet(LoginStart, 0x00, [
        {name, String, string, @name <= 16, @name, "raise \"LoginStart: 'name' was more than 16 chars!\""},
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
        {features_length, Int32, var_int},
        {features, Array(String), string_array, @features_length >= 0, "@features_length", "raise \"FeatureFlags: 'features_length' was negative!\""},
      ])

      define_packet(KnownPacksCB, 0x0E, [
        {known_packs_length, Int32, var_int},
        {known_packs, Array(KnownDataPack), known_data_pack_array, @known_packs_length >= 0, "@known_packs_length", "raise \"KnownPacksCB: 'known_packs_length' was negative!\""},
      ])

      define_packet(RegistryData, 0x0E, [
        {registry_id, String, string},
        {entries_length, Int32, var_int},
        {entries, Array(RegistryData), registry_data_array, @entries_length >= 0, "@entries_length", "raise \"RegistryData: 'entries_length' was negative!\""},
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
        {known_packs_length, Int32, var_int},
        {known_packs, Array(KnownDataPack), known_data_pack_array, @known_packs_length >= 0, "@known_packs_length", "raise \"KnownPacksCB: 'known_packs_length' was negative!\""},
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
