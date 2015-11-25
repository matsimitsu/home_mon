module Components
  class Blokker < Components::Switch
    attr_reader :code, :name, :icon

    def self.setup(hm)
      if hm.config['components']['blokker']
        hm.config['components']['blokker'].each do |id, att|
          new(hm, id, att)
        end
      end
    end

    def initialize(hm, attributes)
      @name = attributes['name']
      @code = attributes['code']
      @icon = attributes['icon']
      super(hm)
    end

    def switch_on
      system "sudo 'blokker' #{code} on"
      self.state = 'on'
    end

    def switch_off
      system "sudo 'blokker' #{code} off"
      self.state = 'off'
    end
  end
end
