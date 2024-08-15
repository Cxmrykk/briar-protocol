### Note: copy/pasted code during testing development stage used for REFERENCE ONLY

**1. Testing VarInt, packet buffer, packet parser and compression**
```crystal
require "./buffer"
require "./parser"

#
# Tests compression and varint values
# Should match the sample varints
# 

parser = PacketParser.new
parser.compression = 100

buffer = PacketBuffer.new
[0, 1, 2, 127, 128, 255, 25565, 2097151, 2147483647].each do |i|
  puts i
  buffer.write_var_int(i)
end

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
```

**2. Briar library proof of concept**
```crystal
require "briar"

client = Briar::Client.new("Player123", "d8a3fe8dds9")
client.connect("Hypixel.net", 25565)

# Returns nil when timeout runs out. Locks the current fiber until event triggers or timeout
client.event?(:login) do
  puts "Client has connected to the server"
end

begin
  # Throws an exception when timeout runs out. Locks the current fiber until event triggers or timeout
  client.event(:login, 5.seconds) do |login_time, motd|
    client.puts "Hello world!"
  end
rescue ex : Briar::Event::Timeout
  puts "Client was unable to log in (timeout)"
end

spawn {
  loop {
    client.event?(:message) do |msg|
      case match = msg.to_s
      when /#{client.username} has joined the game!/
        puts "Client has joined the game."
      when /You have been kicked for inactivity./
        puts "Client was disconnected due to inactivity."
        client.disconnect
      end
    end
  }
}

until client.disconnected
  sleep 1.seconds
end
```

**3. Testing the new EventManager class**
```crystal
require "./event"

# Define the EventManager class
create_event_manager([
  {FooBar, foo_bar, {Int32, Int32, Int32}},
  {BarFoo, bar_foo, {Int16, Int8, Int32}},
])

# Create an instance of EventManager
client = EventManager.new

spawn do
  client.receive(:foo_bar, 3.seconds) do |a, b|
    puts "FOO_BAR!!!! #{a} + #{b} = #{a + b}"
  end

  puts "code executed.!!!!!!!"
end

puts "test"
sleep 3.seconds
puts "about to send"
client.send(:foo_bar, 10, 10, 10)
sleep 1.seconds
puts "finished"

```