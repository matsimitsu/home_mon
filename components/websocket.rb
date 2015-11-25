module Components
  class Websocket
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      new(hm).start_websocket
    end

    def start_websocket
      WebSocket::EventMachine::Server.start(:host => "0.0.0.0", :port => 8081) do |ws|
        subscribe('#', self.id) do |channel, message|
          puts 'mooo'
          ws.send(JSON.generate({:channel => channel, :message => message}))
        end
      end
    end
  end
end
