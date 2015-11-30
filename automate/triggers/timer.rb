module Automate
  module Triggers
    class Timer < Automate::Triggers::Base
      set_callback :initialize, :after, :track_time

      # Subscribe to timer ticks
      def track_time
        subscribe('timer/tick', id , :check_for_trigger)
      end

      # Check if time matches our trigger time
      def check_for_trigger(params)
        given_time = ::Time.parse(params['time'])

        if match_time?(given_time) && match_days?(given_time)
          automation.trigger
        end
      end

      # Match the trigger time with our time
      def match_time?(given_time)
        our_time = Time.parse(attributes['time'])
        given_time.utc.strftime("%H%M") == our_time.utc.strftime("%H%M")
      end

      # Match each given days, if any
      def match_days?(given_time)
        our_days = [*attributes['days']]
        return true if !our_days
        our_days.each do |our_day|
          return true if match_day?(given_time, our_day)
        end
        return false
      end

      # Match our day with given time
      def match_day?(given_time, our_day)

        # Convert to weekday
        given_day = given_time.strftime('%a')

        # Check for special values, like 'weekday' and 'weekend'
        case given_day
        when 'all' then
          true
        when 'weekday' then
          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].include?(given_day)
        when 'weekend' then
          ['Sun', 'Sat'].include?(given_day)
        else
          our_day == given_day
        end
      end
    end
  end
end
