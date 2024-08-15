require "uuid"

# Macro to create an EventManager class with custom event definitions
macro define_event_manager(definitions)
  class EventManager
    # Custom exception for timeout events
    class Timeout < Exception; end

    # Create enums for each event type
    {% for definition in definitions %}
      enum {{definition[0]}}
        {{definition[0]}}
      end
    {% end %}

    # Define argument types for each event
    {% for definition in definitions %}
      alias {{definition[0]}}Args = Tuple({{definition[2].splat}})
    {% end %}

    # Initialize channels for each event type
    def initialize
      {% for definition in definitions %}
        @channel_{{definition[1]}} = {} of UUID => Channel({{definition[0]}}Args)
      {% end %}
    end

    # Define receive methods for each event type
    {% for definition in definitions %}
      def receive(name : {{definition[0]}}, timeout : Time::Span? = nil, &block : ({{definition[2].splat}}) -> _)
        id = UUID.random
        channel = Channel({{definition[0]}}Args).new

        @channel_{{definition[1]}}[id] = channel

        begin
          if timeout
            # Use select to handle timeout
            select
            when args = channel.receive
              block.call(*args)
            when timeout(timeout)
              raise Timeout.new("Event #{name} timed out")
            end
          else
            args = channel.receive
            block.call(*args)
          end
        rescue ex
          channel.close
          raise ex
        end
      end
    {% end %}

    # Define receive? methods that return nil on timeout
    {% for definition in definitions %}
      def receive?(name : {{definition[0]}}, timeout : Time::Span? = nil, &block : ({{definition[2].splat}}) -> _) : {{definition[0]}}?
        receive(name, timeout, &block)
      rescue Timeout
        nil
      end
    {% end %}

    # Define send methods for each event type
    {% for definition in definitions %}
      def send(name : {{definition[0]}}, *args)
        @channel_{{definition[1]}}.each do |id, channel|
          unless channel.closed?
            channel.send(args)
            channel.close
          end
        rescue Channel::ClosedError
        ensure
          @channel_{{definition[1]}}.delete(id)
        end
      end
    {% end %}
  end
end
