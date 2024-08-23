# Defines a packet class that inherits from RawPacket.
#
# Arguments:
#   name        : Name of the packet class to be defined
#   id          : ID of the packet
#   definitions : Array of packet field definitions
#
# Field Definition Formats:
#   1. [field_name, field_type, serialization_method]
#   2. [field_name, field_type, serialization_method, condition]
#   3. [field_name, field_type, serialization_method, condition, true_case, false_case]
#
# Generated Features:
#   - Getter methods for each field
#   - Initializer that takes all fields as arguments and serializes them
#   - Initializer that takes a RawPacket and deserializes it
#   - to_tuple method that returns all fields as a tuple
#
# Conditional Serialization/Deserialization:
#   condition : Determines whether the property type can be set to more than one value
#               Example: If 0, set to nil, otherwise perform read/write function
# 
#   true_case : (Optional) Additional argument for read/write function when condition is true
#               If not provided, no additional argument is passed
# 
#   false_case: (Optional) Value when condition is false
#               Defaults to "nil" if not provided
#
# Deserialization Behavior:
#   - When condition is true: Field is read using the specified serialization method
#   - When condition is false: Field is set to false_case value (or nil if not provided)

macro define_packet(name, id, definitions)
  class {{name}} < RawPacket
    {% for definition in definitions %}
      {% if definition.size >= 4 %}
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
        {% if definition.size >= 4 %}
          {% condition = definition[3] %}
          {% true_case = definition[4] ? ", #{definition[4]}" : "" %}
          {% false_case = definition[5] || "nil" %}
          if {{condition}}
            buffer.write_{{definition[2]}}(@{{definition[0]}}.not_nil!{{true_case.id}})
          else
            {{false_case.id}}
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
        {% if definition.size >= 4 %}
          {% condition = definition[3] %}
          {% true_case = definition[4] || "" %}
          {% false_case = definition[5] || "nil" %}
          @{{definition[0]}} = if {{condition}}
            buffer.read_{{definition[2]}}({{true_case.id}})
          else
            {{false_case.id}}
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
