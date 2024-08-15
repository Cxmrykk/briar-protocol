require "./client"

client = Client.new("test")

client.connect("localhost", 25565)

loop {}