module Components
  class Automate < Core::Component
    attr_reader :trigger, :filters
    set_callback :initialize, :after, :load_triggers

    def self.setup(hm)
      if hm.component_config('automate')
        hm.component_config('automate').each do |id, att|
          new(hm, att.merge('id' => id, 'visible' => false))
        end
      end
    end

    def load_triggers
      # Load all the triggers
      state['triggers'].each do |trigger|
        klass = "Automate::Triggers::#{trigger['type'].classify}".constantize
        klass.new(hm, self, trigger)
      end
    end

    def trigger
      execute_actions if match_filters?
    end

    def execute_actions
      state['actions'].each do |action|
        publish("components/#{action['component']}", action['params'])
      end
    end

    def match_filters?
      state.fetch(:filters, []).each do |filter|
        klass = "Automate::Filters::#{filter['type'].classify}".constantize
        return false unless klass.new(hm, self, filter).match?
      end

      true
    end
  end
end

require 'automate/triggers'
