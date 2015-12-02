require 'active_support/core_ext/hash'  #from_xml

module Components
  class Train < Core::Component
    set_callback :initialize, :after, :update

    def self.setup(hm)
      new(hm) if hm.component_config('train').present?
    end

    # Override the id, we only have one rain component
    def id; 'train'; end

    def update
      config     = hm.component_config('train')
      user       = config['user']
      password   = config['password']
      station    = config['station']

      # Get the goods
      response   = RestClient.get("http://#{CGI.escape(user)}:#{password}@webservices.ns.nl/ns-api-avt?station=#{station}")

      # Parse the xml to a hash
      hash       = Hash.from_xml(response.body)

      # Get the first 4 departures
      departures = hash['ActueleVertrekTijden']['VertrekkendeTrein'].first(4)

      # Update the state
      change_state(:departures => departures)

      # Advance the current time by 10 minutes, queue the next API fetch
      timestamp = Time.now.advance(:minutes => 10).utc.change(:sec => 0, :usec => 0)
      subscribe_timestamp(timestamp, :update)
    end
  end
end

