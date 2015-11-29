require 'sun_times'
module Components
  class Sun < Core::Component
    set_callback :initialize, :after, :update

    def self.setup(hm)
      if hm.config['lat'] && hm.config['lng']
        new(hm)
      else
        hm.logger.warn("lat/lng not set in config")
      end
    end

    # Override the id, we only have one sun
    def id; 'sun'; end

    def sun_times; @sun_times ||= SunTimes.new; end

    # Accessors for the lat/lng, as we use them a lot
    def lat; hm.config['lat']; end
    def lng; hm.config['lng']; end

    def expose_state
      {
        :now          => now,
        :next_sunrise => next_sunrise,
        :next_sunset  => next_sunset,
        :next_change  => next_change
      }
    end

    def now
      if (sun_times.rise(Date.today, lat, lng).utc < Time.now.utc &&
          sun_times.set(Date.today, lat, lng).utc > Time.now)
        'day'
      else
        'night'
      end
    end

    def next_sunrise
      rise = sun_times.rise(Date.today, lat, lng).utc
      if rise > Time.now.utc
        rise
      else
        sun_times.rise(Date.tomorrow, lat, lng).utc
      end
    end

    def next_sunset
      set = sun_times.set(Date.today, lat, lng).utc
       if set > Time.now.utc
         set
       else
         sun_times.set(Date.tomorrow, lat, lng).utc
       end
    end

    def next_change
      [next_sunrise, next_sunset].min
    end

    def update
      timestamp = next_change.advance(:seconds => 1).utc
      change_state(expose_state)

      subscribe_timestamp(timestamp, :update)
    end
  end
end
