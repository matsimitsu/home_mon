require 'sun_times'
module Components
  class Sun
    attr_reader :lat, :lng, :sun_times
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
      @id  = 'sun'
      @lat = lat
      @lng = lng
      @sun_times ||= SunTimes.new
      super(hm)
    end

    def initial_state
      now
    end

    def now
      if (sun_times.rise(Date.today, @lat, @lng).utc < Time.now.utc &&
          sun_times.set(Date.today, @lat, @lng).utc > Time.now)
        'day'
      else
        'night'
      end
    end

    def next_sunrise
      rise = sun_times.rise(Date.today, @lat, @lng).utc
      if rise > Time.now.utc
        rise
      else
        sun_times.rise(Date.tomorrow, @lat, @lng).utc
      end
    end

    def next_sunset
      set = sun_times.set(Date.today, @lat, @lng).utc
       if set > Time.now.utc
         set
       else
         sun_times.set(Date.tomorrow, @lat, @lng).utc
       end
    end

    def next_change
      [next_sunrise, next_sunset].min
    end

    def update
      timestamp = next_change.advance(:seconds => 1).utc
      change_state(now)

      subscribe_timestamp(timestamp, :update)
    end
  end
end
