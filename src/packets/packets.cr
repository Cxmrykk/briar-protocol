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
    end
    
    module S
      define_packet(KeepAlive, 0x00, [
        {keep_alive_id, Int32, var_int},
      ])
    end
  end
end
