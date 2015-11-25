module HM
  module Helpers
    module Publisher

      def publish(channel, message)
        hm.publish(channel, message)
      end

    end
  end
end

