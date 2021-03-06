module HM
  class Subscription
    attr_reader :channel, :id, :block

    def initialize(channel, id, block)
      @channel = channel
      @id      = id
      @block   = block
    end

    def match_channel?(given_channel)
      # Return true if the channel matches the 'catch-all'
      return true if channel == '#'

      # Return true if channel is an exact match
      return true if given_channel == channel

      # Test for a wildcard string ('foo/*')
      if channel.end_with?('*')
        channel_without_wildcard = channel.gsub('*', '')
        return true if given_channel.start_with?(channel_without_wildcard)
      end
      return false
    end

  end
end
