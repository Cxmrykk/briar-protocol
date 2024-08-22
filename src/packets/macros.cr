macro define_packet(name, id, definitions)
  class {{name}} < RawPacket
    {% for definition in definitions %}
      {% if definition.size == 4 %}
        getter {{definition[0]}} : {{definition[1]}}
      {% else %}
        getter {{definition[0]}} : {{definition[1]}}
      {% end %}
    {% end %}

    def initialize({% for definition, index in definitions %}
      @{{definition[0]}} : {{definition[1]}}{% if index < definitions.size - 1 %}, {% end %}
    {% end %})
      buffer = PacketBuffer.new
      {% for definition in definitions %}
        {% if definition.size == 4 %}
          if {{definition[3]}}
            buffer.write_{{definition[2]}}(@{{definition[0]}}.not_nil!)
          end
        {% else %}
          buffer.write_{{definition[2]}}(@{{definition[0]}})
        {% end %}
      {% end %}
      @id = {{id}}
      @data = buffer.data
    end

    def initialize(packet : RawPacket)
      buffer = PacketBuffer.new(packet.data)
      {% for definition in definitions %}
        {% if definition.size == 4 %}
          @{{definition[0]}} = if {{definition[3]}}
            buffer.read_{{definition[2]}}
          else
            nil
          end
        {% else %}
          @{{definition[0]}} = buffer.read_{{definition[2]}}
        {% end %}
      {% end %}
      @id = {{id}}
      @data = buffer.data
    end

    def to_tuple : Tuple({% for definition, index in definitions %}
      {{definition[1]}}{% if index < definitions.size - 1 %}, {% end %}
    {% end %})
      { {% for definition, index in definitions %}
        @{{definition[0]}}{% if index < definitions.size - 1 %}, {% end %}
      {% end %} }
    end
  end
end