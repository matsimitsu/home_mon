module Components
  class Lifx < Core::Component
    set_callback :initialize, :after, :listen_for_changes

    def self.setup(hm)
      if hm.component_config('lifx')
        hm.component_config('lifx')['entities'].each do |id, att|
          new(hm, att.merge('id' => id))
        end
      end
    end

    def id
      state['id']
    end

    def listen_for_changes
      subscribe("components/#{name}/#{id}/off", name, :switch_off)
      subscribe("components/#{name}/#{id}/on", name, :switch_on)
      subscribe("components/#{name}/#{id}/update", name, :switch)
    end

    def switch_on(given_params)
      switch(given_params.merge('power' => 'on'))
    end

    def switch_off(given_params)
      switch(given_params.merge('power' => 'off'))
    end

    def switch(params)
      payload = {
        'duration'   => params['duration'] || 5,
        'brightness' => (params['brightness'] || 50).to_f / 100
      }
      payload['power'] = params['power'] if params['power']
      payload['color'] = params['color'] if params['color']

      api_key = hm.component_config('lifx')['api_key']
      RestClient::Request.execute(
        :method  => :put,
        :url     => "https://api.lifx.com/v1/lights/#{state['code']}/state",
        :payload => payload,
        :headers => {'Authorization' => "Bearer #{api_key}"}
      )
      change_state(payload)
    end

  end
end
