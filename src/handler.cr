require "./packets"
require "./parser"

#
# Formats received packets into structured data
#
class PacketHandler
  def initialize
    @parser = PacketParser.new
  end

  def set_compression(compression : Int32?)
    @parser.compression = compression
  end

  #
  # Parses a buffer into RawPacket, triggers an event based on it.
  # Todo: overload with macro for packet types (defined in packets.cr)
  # 
  def receive
  end
end
