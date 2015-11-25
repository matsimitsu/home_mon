module Components
  class Rain < Components::Base
    set_callback :initialize, :after, :update

    def self.setup(hm)
      if hm.config['lat'] && hm.config['lng']
        new(hm)
      else
        hm.logger.warn("lat/lng not set in config")
      end
    end

    # Override the id, we only have one rain component
    def id; 'rain'; end

    # Accessors for the lat/lng, as we use them a lot
    def lat; hm.config['lat']; end
    def lng; hm.config['lng']; end


    def update
      response = RestClient.get("http://gps.buienradar.nl/getrr.php?lat=#{lat}&lon=#{lng}")

      # Get the forecast from the response.
      forecast = forecast_from_response(response)

      # We want to chane the state if there's a chance of rain
      rain_or_shine = rain_or_shine_from_forecast(forecast)

      # Update the state
      change_state(:rain_or_shine => rain_or_shine, :forecast => forecast)

      # Advance the current time by 5 minutes, queue the next API fetch
      timestamp = Time.now.advance(:minutes => 5).utc.change(:sec => 0, :usec => 0)
      subscribe_timestamp(timestamp, :update)
    end

    # Returns 'rain' if there's precipitation in the next 30 minutes
    # Returns 'shine' if there isn't
    def rain_or_shine_from_forecast(forecast)
      forecast[0..6].map{ |i| i['count']}.reduce(:+) > 0 ? 'rain' : 'shine'
    end

    # Returns an array of timestamps (5 min. interval) and precipitation in mm
    def forecast_from_response(response)
      [].tap do |arr|
        # Time is posted in 5 minute increments,
        # instead of parsing each timestamp
        # just advance the time for each line.
        first = Time.parse(response.lines.first.split('|').last)

        # Loop trough the result lines and split the time from the precipitation
        response.lines.each_with_index do |line, index|
          rainfall = line.split('|').first
          time     = first.advance(:minutes => (5 * index))

          # Push into result set
          arr.push({'ts' => time.utc, 'count' => rainfall.to_i})
        end
      end
    end
  end
end

