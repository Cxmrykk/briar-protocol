#
# Defines read/write functions for an array type.
# Splat argument is used in write function for packet definitions, where the length
# is sometimes specified (but unused) in the write function.
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