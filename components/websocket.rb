require 'em-websocket'
module Components
  class Websocket < Core::Component
    set_callback :initialize, :after, :start_websocket

    def self.setup(hm)
      if hm.component_config('websocket')
        new(hm, hm.component_config('websocket'))
      end
    end

    def start_websocket
      @channel = EM::Channel.new
      EM::WebSocket.run(:host => "0.0.0.0", :port => state['port']) do |ws|
        logger.debug "Websocket server started on #{state['port']}"
        ws.onopen {
         sid = @channel.subscribe { |msg| ws.send msg }

         ws.onclose {
           @channel.unsubscribe(sid)
         }
       }
      end

      subscribe('event/*', id) do |channel, message|
        @channel.push(JSON.generate({:channel => channel, :message => message}))
      end
    end
  end
end
