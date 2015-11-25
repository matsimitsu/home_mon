module HM
  class Subscriber
    attr_reader :subscriptions

    def initialize
      @subscriptions = []
    end

    def subscribe(channel, id, &block)
      @subscriptions << Subscription.new(channel, id, block)
    end

    def unsubscribe(channel, id)
      @subscriptions.reject! { |s| s.id == id && s.channel == channel }
    end

    def matching_subscriptions(given_channel)
      @subscriptions.select { |s| s.match_channel?(given_channel) }
    end

    def process_channel_payload(channel, payload)
      matching_subscriptions(channel).each do |subscription|
        subscription.block.call(channel, payload)
      end
    end
  end
end
