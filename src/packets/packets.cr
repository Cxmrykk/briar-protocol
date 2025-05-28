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
        {properties, Array(TextureProperty), texture_property_array, @properties_length <= 16, "@properties_length", "raise \"LoginSuccess: 'properties_length' was more than 16!\""}
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
    end
  end

  module Configuration
    module C
    end

    module S
    end
  end

  module Play
    module C
    end

    module S
    end
  end
end
