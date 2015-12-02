module Components
  class Kaku < Components::Switch
    def self.setup(hm)
      if hm.config['components']['kaku']
        hm.config['components']['kaku'].each do |id, att|
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
      system "sudo 'kaku' #{code} on"
      change_state({:power => 'on'})
    end

    def switch_off
      system "sudo 'kaku' #{code} off"
      change_state({:power => 'off'})
    end

  end
end
