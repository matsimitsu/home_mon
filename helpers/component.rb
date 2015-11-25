module HM
  module Helpers
    module Component
      attr_reader :hm, :logger, :name, :config, :id, :state
      extend Forwardable

      def_delegator :@hm, :logger, :logger
      def_delegator :@hm, :config, :config

      def initialize(hm)
        @hm     = hm
        @id   ||= "#{self.class.name.split('::').last.downcase}-#{SecureRandom.hex(3)}"
        @state  = defined?(initial_state) ? initial_state : nil
        hm.components.push(self)
        publish('event/device_added', JSON.generate({:component => self.class, :id => id}))
        listen_for_changes if defined? listen_for_changes
      end

      def change_state(new_state, other_attributes={})
        old_state = @state
        @state = new_state
        force = other_attributes.delete(:force) || false
        other_attributes.each do |key, val|
          instance_variable_set(:"@#{key}", val)
        end

        changes = {:id => id, :state => state, :state_was => old_state}.merge(other_attributes)
        if old_state != new_state || force
          publish('event/state_changed', JSON.generate(changes))
        end
      end
    end
  end
end
