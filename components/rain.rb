module Components
  class Rain
    attr_reader :lat, :lng, :forecast
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      if hm.config['lat'] && hm.config['lng']
        new(hm, hm.config['lat'], hm.config['lng']).update
      else
        hm.logger.warn("lat/lng not set in config")
      end
    end

    def initialize(hm, lat, lng)
      @id  = 'rain'
      @lat = lat
      @lng = lng
      super(hm)
    end

    def update
      response = RestClient.get("http://gps.buienradar.nl/getrr.php?lat=#{lat}&lon=#{lng}")
      forecast = [].tap do |arr|
        first = Time.parse(response.lines.first.split('|').last)
        response.lines.each_with_index do |line, index|
          rainfall = line.split('|').first
          time = first.advance(:minutes => (5 * index))
          arr.push({'ts' => time.utc, 'count' => rainfall.to_i})
        end
      end

      state = forecast[0..6].map{ |i| i['count']}.reduce(:+) > 0 ? 'rain' : 'no_rain'
      change_state(state, :forecast => forecast, :force => true)

      timestamp = Time.now.advance(:minutes => 1).utc.change(:sec => 0, :usec => 0)
      subscribe_timestamp(timestamp, :update)
    end
  end
end

