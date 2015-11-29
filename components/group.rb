module Components
  class Group < Core::Component
    set_callback :initialize, :after, :listen_for_changes

    def self.setup(hm)
      if hm.component_config('group')
        hm.component_config('group').each do |id, att|
          new(hm, att.merge('id' => id, 'power' => 'off'))
        end
      end
    end

    def id
      state['id']
    end

    def switch_on(params)
      state['members'].each do |member|
        publish("components/#{member}/on", params)
      end
      change_state :power => 'on'
    end

    def switch_off(params)
      state['members'].each do |member|
        publish("components/#{member}/off", params)
      end
      change_state :power => 'off'
    end

    def listen_for_changes
      subscribe("components/#{name}/#{id}/off", id, :switch_off)
      subscribe("components/#{name}/#{id}/on", id, :switch_on)
    end

  end
end
