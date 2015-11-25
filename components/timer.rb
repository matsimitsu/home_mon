module Components
  class Timer
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      self.subscribe_once(hm, 'core/start', self.name) do |channel, message|
        new(hm).start_timer
      end
    end

    def start_timer
      @last_run_minute = -1
      EventMachine::PeriodicTimer.new(1.0) do
        now = Time.now
        if @last_run_minute != now.min
          hm.publish('timer/tick', Time.now.utc.change(:sec => 0, :usec => 0).iso8601)
          @last_run_minute = now.min
        end
      end
    end
  end
end
