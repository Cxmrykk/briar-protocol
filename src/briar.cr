require "./client"

client = Client.new("test")

client.connect("localhost", 25565)

client.receive(:login_success) do
  puts "Client has successfully logged in!"
end

loop {}