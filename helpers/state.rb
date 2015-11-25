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

        changed = old_state == state

        if changed || force
          publish('event/state_changed', expose_state.merge('id' => id))
        end

        state
      end
    end
  end
end
