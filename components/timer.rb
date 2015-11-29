module Components
  class Timer < Core::Component

    set_callback :initialize, :after, :start_timer

    def self.setup(hm)
      new(hm)
    end

    # Run a timer every 10 seconds, if the minute has changed
    # round it down and publish it to the `timer/tick` channel.
    def start_timer
      @last_run_minute = -1
      EventMachine::PeriodicTimer.new(10.0) do
        now = Time.now.utc
        if @last_run_minute != now.min
          @last_run_minute = now.min
          publish(
            'timer/tick',
            {'time' => now.change(:sec => 0, :usec => 0).iso8601}
          )
        end
      end
    end
  end
end
