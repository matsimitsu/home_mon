module Components
  class Websocket < Components::Base
    set_callback :initialize, :after, :start_websocket

    def self.setup(hm)
      new(hm)
    end

    def start_websocket
      subscribe('#', id) do |channel, message|
        WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => 8081) do |ws|
          ws.send(JSON.generate({:channel => channel, :message => message}))
        end
      end
    end
  end
end
