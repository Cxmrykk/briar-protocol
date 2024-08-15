require "socket"
require "./event"
require "./handler"

BUFFER_SIZE = 1024

# Define the EventManager class
# todo: define in "packets.cr", call macros here
create_event_manager([
  {FooBar, foo_bar, {Int32, Int32, Int32}},
  {BarFoo, bar_foo, {Int16, Int8, Int32}},
])

class Client < EventManager
  @socket : TCPSocket?
  @handler : PacketHandler
  @buffer : Bytes

  def initialize(username : String, password : String? = nil)
    super()
    @handler = PacketHandler.new
    @buffer = Bytes.new(BUFFER_SIZE)
  end

  def connect(host : String, port : Int32 = 25565)
    @socket = TCPSocket.new(host, port)
    spawn do
      until @socket.nil?
        break unless socket = @socket
        break if socket.closed?
        socket.read(@buffer)
        puts @buffer.size
      end
    end
  end

  def close
    @socket.try &.close
  end
end
