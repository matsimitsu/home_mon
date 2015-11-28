module Components
  class Lifx < Components::Base
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
    end

    def switch_on(given_params)
      params = {
        'power'      => 'on',
        'duration'   => given_params['duration'] || 5,
        'brightness' => (given_params['brightness'] || 50).to_f / 100
      }
      switch(params)
      change_state(params)
    end

    def switch_off(given_params)
      params = {
        'power'    => 'off',
        'duration' => given_params['duration'] || 5,
      }
      switch(params)
      change_state(params)
    end

    def switch(payload)
      api_key = hm.component_config('lifx')['api_key']
      RestClient::Request.execute(
        :method  => :put,
        :url     => "https://api.lifx.com/v1/lights/#{state['code']}/state",
        :payload => payload,
        :headers => {'Authorization' => "Bearer #{api_key}"}
      )
    end

  end
end
