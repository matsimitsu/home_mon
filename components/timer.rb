module Components
  class Timer
    include HM::Helpers::Component
    include HM::Helpers::Publisher

    def self.setup(hm)
      # Once the core has started, start a timer
      self.subscribe_once(hm, 'core/start', self.name) do |channel, message|
        new(hm).start_timer
      end
    end

    # Run a timer every 10 seconds, if the minute has changed
    # round it down and publish it to the `timer/tick` channel.
    def start_timer
      @last_run_minute = -1
      EventMachine::PeriodicTimer.new(10.0) do
        now = Time.now
        if @last_run_minute != now.min
          @last_run_minute = now.min
          hm.publish(
            'timer/tick',
            {:time => now.utc.change(:sec => 0, :usec => 0).iso8601}
          )
        end
      end
    end
  end
end
