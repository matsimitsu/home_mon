module Components
  class Monitor
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      new(hm).start_monitor if hm.config['components']['monitor']
    end

    def start_monitor
      subscribe('#', self.name) do |channel, message|
        logger.debug("Message received on #{channel}: #{message}")
      end
    end
  end
end
