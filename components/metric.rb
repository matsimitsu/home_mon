
module Components
  class Metric < Core::Component
    set_callback :initialize, :after, :listen_for_changes

    def self.setup(hm)
      if hm.component_config('metric')
        hm.component_config('metric').each do |id, att|
          new(hm, att.merge('id' => id))
        end
      end
    end

    def id
      state['id']
    end

    def database
      hm.database
    end

    def key
      state['key']
    end

    def expose_state
      super.merge(:history => history)
    end

    def history
      statement = database.prepare <<-SQL
        SELECT * from metrics
        WHERE `key` = ? AND `created_at` > ?
      SQL

      results = statement.execute(key, 24.hours.ago.utc.beginning_of_hour)

      (0..24).to_a.reverse.map do |hour|
        ts    = hour.hours.ago.beginning_of_hour
        value = results.find { |r| r['created_at'].utc == ts.utc}.try(:[], 'value') || 0
        {'ts'=> ts.utc,'value' => value}
      end
    end

    def store_metric(value)
      time = Time.now.utc.beginning_of_hour
      statement = database.prepare <<-SQL
        INSERT INTO metrics (`created_at`,`key`,`value`)
        VALUES (?,?,?)
        ON DUPLICATE KEY UPDATE `value` = `value` + ?
      SQL
      statement.execute(time, key, value, value)
    end

    def process_metric(payload)
      value = payload['value']
      store_metric(value)
      change_state(:history => history)
    end

    def listen_for_changes
      subscribe(state['listen'], id, :process_metric)
    end

  end
end
