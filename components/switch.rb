module Components
  class Switch
    attr_reader :state
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      true
    end

    def initialize(hm)
      super(hm)
    end

    def initial_state
      'off'
    end

    def listen_for_changes
      subscribe("switches/#{id}/off", id, :switch_off)
      subscribe("switches/#{id}/on", id, :switch_on)
    end

    def switch_on
      raise 'Not implemented'
    end

    def switch_off
      raise 'Not implemented'
    end

  end
end
