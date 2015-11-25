module Components
  class Kaku < Components::Switch
    attr_reader :code, :name, :icon

    def self.setup(hm)
      if hm.config['components']['kaku']
        hm.config['components']['kaku'].each do |id, att|
          new(hm, id, att)
        end
      end
    end

    def initialize(hm, id, att)
      @id   = id
      @name = att['name']
      @code = att['code']
      @icon = att['icon']
      super(hm)
    end

    def switch_on
      #system "sudo 'kaku' #{code} on"
      change_state 'on'
    end

    def switch_off
      #system "sudo 'kaku' #{code} off"
      change_state 'off'
    end

  end
end
