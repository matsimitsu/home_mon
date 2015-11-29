module Components
  class Scene < Core::Component
    set_callback :initialize, :after, :listen_for_changes

    def self.setup(hm)
      if hm.component_config('scene')
        hm.component_config('scene').each do |id, att|
          new(hm, att.merge('id' => id))
        end
      end
    end

    def id
      state['id']
    end

    def trigger(params)
      state['actions'].each do |action|
        trigger_params = params.merge(action['params'] || {})
        publish("components/#{action['component']}", trigger_params)
      end
      publish('scenes/triggered', {'name' => name, 'id' => id})
    end

    def listen_for_changes
      subscribe("components/#{name}/#{id}/trigger", id, :trigger)
    end

  end
end
