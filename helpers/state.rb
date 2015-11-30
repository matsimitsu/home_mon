module HM
  module Helpers
    module State

      def expose_state
        state
      end

      def change_state(new_state={})
        force     = new_state.delete(:force) || false
        old_state = state

        state.merge!(new_state)

        if (old_state == state) || force
          publish('event/state_changed', expose_state.merge('id' => id, 'component' => name))
        end

        state
      end
    end
  end
end
