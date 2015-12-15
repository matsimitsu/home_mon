module Components
  class Virtual < Core::Component
    set_callback :initialize, :after, :listen_for_changes

    def self.setup(hm)
      if hm.component_config('virtual')
        hm.component_config('virtual').each do |id, att|
          new(hm, att.merge('id' => id))
        end
      end
    end

    def trigger_actions(params)
      state['actions'].each do |action|
        trigger_params = params.merge(action['params'] || {})
        publish("components/#{action['component']}", trigger_params)
      end
    end

    def listen_for_changes
      subscribe(state['listen'], id, :trigger_actions)
    end

  end
end
