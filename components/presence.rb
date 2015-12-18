require 'arp_scan'

module Components
  class Presence < Core::Component
    set_callback :initialize, :after, :update

    def self.setup(hm)
      if hm.component_config('devices')
        new(hm, {:devices => hm.component_config('devices')})
      end
    end

    # Defer arp scan, so it doesn't block the rest
    def update
      operation = proc { ARPScan('--localnet') }
      callback  = proc { |result| update_callback(result) }
      EventMachine.defer(operation, callback)
    end

    # Update found devices and change state with the any? result (used in filters)
    def update_callback(result)
      result.hosts.each do |host|
        if device = state[:devices].find { |d| d['mac'] == host.mac }
          device['last_seen_at'] = Time.now.utc
        end
      end
      change_state(:any => any?)

      timestamp = Time.now.advance(:minutes => 10).utc.change(:sec => 0, :usec => 0)
      self.subscribe_timestamp(timestamp, :update)
    end

    def any?
      state[:devices].each do |d|
        return true if d['last_seen_at'] && d['last_seen_at'] > 10.minutes.ago.utc
      end
      false
    end

  end
end
