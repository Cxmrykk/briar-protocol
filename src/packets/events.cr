require "./packets"

require "../buffer"

module Events
  include Packets

  module C
    create_event_emitter([

    ])
  end

  module S
    create_server_event_emitter([

    ])
  end
end
