#
# -- Length-specified Array --
#
macro define_array_functions(type, read_func, write_func, *extra_params)
  def {{read_func}}_array(length : Int32{% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}) : Array({{type}})
    (0...length).map { {{read_func.id}}({% if extra_params.size > 0 %}{{extra_params.join(", ").id}}{% end %}) }
  end

  def {{write_func}}_array(array : Array({{type}}){% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}, *_args)
    write_var_int(array.size)
    array.each { |element| {{write_func.id}}(element{% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}) }
  end
end

#
# -- Prefixed Array --
#
macro define_array_prefixed_functions(type, read_func, write_func, *extra_params)
  def {{read_func}}_array_prefixed({% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}) : Array({{type}})
    length = read_var_int
    if length < 0
      Log.warn { "Warning: Prefixed array length was negative, setting to 0." }
      length = 0
    end
    (0...length).map { {{read_func.id}}({% if extra_params.size > 0 %}{{extra_params.join(", ").id}}{% end %}) }
  end

  def {{write_func}}_array_prefixed(array : Array({{type}}){% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}, *_args)
    write_var_int(array.size)
    array.each { |element| {{write_func.id}}(element{% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}) }
  end
end

#
# -- Prefixed Optional
#
macro define_prefixed_optional_functions(type, read_func, write_func, *extra_params)
  def {{read_func}}_prefixed_optional({% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %}) : {{type}} | Nil
    if read_boolean
      {{read_func}}({% if extra_params.size > 0 %}{{extra_params.join(", ").id}}{% end %})
    else
      nil
    end
  end

  def {{write_func}}_prefixed_optional(value : {{type}} | Nil{% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %})
    write_boolean(!value.nil?)
    {{write_func}}({% if extra_params.size > 0 %}, {{extra_params.join(", ").id}}{% end %})
  end
end

#
# -- Generic Structured Data
#

# {entity_id, String, string}

macro define_generic_structured_data(name, type, definitions = [] of Nil)
  alias {{type}} = NamedTuple({% for definition in definitions %}
  {{definition[0]}}: {{definition[1]}},{% end %}
  )

  def read_{{name}} : {{type}}
    \{{% for definition in definitions %}
    {{definition[0]}}: read_{{definition[2]}},{% end %}
    \}
  end

  def write_{{name}}({{name}} : {{type}})
    {% for definition in definitions %}write_{{definition[2]}}({{name}}[:{{definition[0]}}])
    {% end %}
  end
end
