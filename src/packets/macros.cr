macro define_packet(name, id, definitions)
  class {{name}} < RawPacket
    def initialize({% for definition, index in definitions %}
      @{{definition[0]}} : {{definition[1]}}{% if index < definitions.size - 1 %}, {% end %}
    {% end %})
      buffer = PacketBuffer.new
      {% for definition in definitions %}
      buffer.write_{{definition[2]}}(@{{definition[0]}})
      {% end %}
      @id = {{id}}
      @data = buffer.data
    end

    def initialize(packet : RawPacket)
      buffer = PacketBuffer.new(packet.data)
      {% for definition in definitions %}
      @{{definition[0]}} = buffer.read_{{definition[2]}}
      {% end %}
      @id = {{id}}
      @data = buffer.data
    end

    def to_tuple : Tuple({% for definition, index in definitions %}
    {{definition[1]}}{% if index < definitions.size - 1 %}, {% end %}
  {% end %})
    ({% for definition, index in definitions %}
    @{{definition[0]}}{% if index < definitions.size - 1 %}, {% end %}
    {% end %})
    end
  end
end

#
# TODO: generate EventManager arguments
#
