module HM
  module Helpers
    module Subscriber
      extend ActiveSupport::Concern

      class_methods do
        def subscribe(hm, channel, id, &block)
          hm.subscribe(channel, id) do |channel, message|
            block.call(channel, message)
          end
        end

        def subscribe_once(hm, channel, id, &block)
          hm.subscribe(channel, id) do |channel, message|
            block.call(channel, message)
            hm.unsubscribe(channel, id)
          end
        end

        def subscribe_timestamp(hm, time, &block)
          utc = time.utc
          id  = "timer-#{SecureRandom.hex(3)}"
          self.subscribe(hm, 'timer/tick', id) do |channel, message|
            tick_time = Time.parse(message).utc
            if tick_time >= utc
              block.call(channel, message)
              hm.unsubscribe('timer/tick', id)
            end
          end
        end

      end

      def subscribe(channel, id, callback=nil, &block)
        self.class.subscribe(hm, channel, id) do |channel, message|
          if callback
            send(callback)
          elsif block_given?
            block.call(channel, message)
          end
        end
      end

      def subscribe_once(channel, id, callback=nil, &block)
        self.class.subscribe_once(hm, channel, id) do |channel, message|
          if callback
            send(callback)
          elsif block_given?
            block.call(channel, message)
          end
        end
      end

      def subscribe_timestamp(timestamp, callback=nil, &block)
        self.class.subscribe_timestamp(hm, timestamp) do |channel, message|
          if callback
            send(callback)
          elsif block_given?
            block.call(channel, message)
          end
        end
      end
    end
  end
end
