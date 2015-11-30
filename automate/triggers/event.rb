module Automate
  module Triggers
    class Event < Automate::Triggers::Base
      set_callback :initialize, :after, :listen_for_event

      # Subscribe to event
      def listen_for_event
        subscribe(attributes['event'], id , :trigger)
      end

      # Trigger automation
      def trigger
        automation.trigger
      end
    end
  end
end
