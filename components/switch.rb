module Components
  class Switch < Components::Base
    set_callback :initialize, :after, :listen_for_changes

    def listen_for_changes
      subscribe("components/#{name}/#{id}/off", id, :switch_off)
      subscribe("components/#{name}/#{id}/on", id, :switch_on)
    end
  end
end
