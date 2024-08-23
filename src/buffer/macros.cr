macro define_array_functions(type, read_func, write_func, *extra_params)
  def {{read_func}}_array(length : Int32{% if extra_params.size > 0 %}, {{extra_params.join(", ")}}{% end %}) : Array({{type}})
    (0...length).map { {{read_func.id}}({% if extra_params.size > 0 %}{{extra_params.join(", ")}}{% end %}) }
  end

  def {{write_func}}_array(array : Array({{type}}){% if extra_params.size > 0 %}, {{extra_params.join(", ")}}{% end %})
    write_var_int(array.size)
    array.each { |element| {{write_func.id}}(element{% if extra_params.size > 0 %}, {{extra_params.join(", ")}}{% end %}) }
  end
end