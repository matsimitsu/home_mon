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

    def code
      state['code']
    end

    def switch_on
      system "sudo 'blokker' #{code} on"
      change_state({:power => 'on'})
    end

    def switch_off
      system "sudo 'blokker' #{code} off"
      change_state({:power => 'off'})
    end
  end
end
