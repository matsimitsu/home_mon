module Components
  class Lifx
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      if hm.config['components'] && hm.config['components']['lifx']
        self.subscribe(hm, 'timer/trick', self.name) do |channel, message|
          time = Time.parse(message)
          self.update if time && time.min % 5 == 0
        end
      end

      self.update
    end

    def self.update
      puts "Updating LIFX config"
    end

    def log_tick(message)
      logger.debug "MONITOR: #{message.inspect}"
    end

    def listen_for_changes
      subscribe("switches/#{name}/off", name, :switch_off)
      subscribe("switches/#{name}/on", name, :switch_on)
    end

    def switch_on
      switch('on')
    end

    def switch_off
      switch('off')
    end

    def switch(state='on')
      RestClient::Request.execute(
        :method  => :put,
        :url     => "https://api.lifx.com/v1/lights/#{code}/state",
        :payload => {
          "power"    => state,
          "duration" => 5
        },
        :headers => {'Authorization' => "Bearer #{ENV['LIFX_KEY']}"}
      )
    end

  end
end
