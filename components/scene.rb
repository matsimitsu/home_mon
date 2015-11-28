module Components
  class Scene < Components::Base
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

    def trigger(params={})
      state['members'].each do |member|
        trigger_params = params.merge(member['params'] || {})
        publish("components/#{member['component']}", trigger_params)
      end
      publish('scenes/triggered', {'name' => name, 'id' => id})
    end

    def listen_for_changes
      subscribe("components/#{name}/#{id}/trigger", id, :trigger)
    end

  end
end
