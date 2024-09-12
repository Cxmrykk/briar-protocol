# Define case structure for handling packets by ID
macro generate_packet_handler(list)
  case state
  {% for current_state in list %}
  when {{current_state[0]}}
    case packet.id
    {% for data in current_state[1] %}
    when {{data[2]}}
      {{data[1].id}} = {{data[0]}}.new(packet)
      self.handle({{data[1].id}})
      @emitter.emit.{{data[1].id}}({{data[1].id}})
    {% end %}
    else
      Log.warn { "Unknown packet ID: #{"0x%02x" % packet.id} (length: #{packet.data.size})" }
    end
  {% end %}
  end
end

macro generate_handler(definitions, emitter)
  {% handshaking_packets = definitions[0] %}
  {% status_packets = definitions[1] %}
  {% login_packets = definitions[2] %}
  {% play_packets = definitions[3] %}

  # Initialize the packet parser
  def initialize
    @parser = PacketParser.new
    @emitter = {{emitter}}.new
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
