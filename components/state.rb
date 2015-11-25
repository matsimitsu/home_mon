module Components
  class State
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      new(hm).start_monitor
    end

    def start_monitor
      subscribe('event/state_changed', self.name) do |channel, message|
        logger.debug(message)
      end
    end
  end
end
