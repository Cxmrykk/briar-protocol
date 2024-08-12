require "./buffer"
require "./parser"

parser = PacketParser.new
parser.compression = 100

buffer = PacketBuffer.new
#[0, 1, 2, 127, 128, 255, 25565, 2097151, 2147483647].each do |i|
#  puts i
#  buffer.write_var_int(i)
#end

[-1, -2147483648].each do |i|
  puts i
  buffer.write_var_int(i)
end

packet = RawPacket.new(0x00, buffer.data)
compressed_data = parser.format(packet)

puts packet.slice
puts "size: #{packet.slice.size}"

puts compressed_data
puts "size: #{compressed_data.size}"

decompressed_packet = parser.parse(compressed_data)
puts decompressed_packet.slice
