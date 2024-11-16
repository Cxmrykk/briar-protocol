#### Example 1: `hello_world.cr`
- Join a server, say something, disconnect

```crystal
require "briar-protocol"

# offline mode (specify email and password to use microsoft account authentication)
client = Briar::Client.new("username123")

client.on.login_success do
  # inform the server you have successfully arrived
  puts "Client connected!"
  client.write(Play::S::Chat.new("Fair dinkum"))

  # disconnect after 5 seconds
  sleep 5
  client.disconnect
end

client.connect("localhost")
puts "Client disconnected!"
```
