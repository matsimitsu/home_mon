module Components
  class Blokker < Components::Switch
    def self.setup(hm)
      if hm.config['components']['blokker']
        hm.config['components']['blokker'].each do |id, att|
          new(hm, att.merge('id' => id))
        end
      end
    end

    def id
      state['id']
    end

    def switch_on(_, params)
      system "sudo 'blokker' #{code} on"
      self.state = 'on'
    end

    def switch_off(_, params)
      system "sudo 'blokker' #{code} off"
      self.state = 'off'
    end
  end
end
