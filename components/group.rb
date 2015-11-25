module Components
  class Group
    attr_reader :state
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      if hm.config['components']['group']
        hm.config['components']['group'].each do |id, att|
          new(hm, id, att)
        end
      end
    end

    def initialize(hm, id, att)
      @id      = id
      @name    = att['name']
      @icon    = att['icon']
      @members = att['members']
      super(hm)
    end

    def switch_on
      @members.each do |member|
        publish("switches/#{member}/on", nil)
      end
      change_state 'on'
    end

    def switch_off
      @members.each do |member|
        publish("switches/#{member}/on", nil)
      end
      change_state 'off'
    end


    def listen_for_changes
      subscribe("switches/#{id}/off", id, :switch_off)
      subscribe("switches/#{id}/on", id, :switch_on)
    end

  end
end
