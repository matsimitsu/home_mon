module HM
  module Helpers
    module Publisher

      def channel_prefix
        self.class.name.split('::').last.downcase
      end

      def publish(channel, message)
        hm.publish(channel, message)
      end
    end
  end
end

