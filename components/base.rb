require 'helpers/subscriber'
require 'helpers/state'
require 'helpers/publisher'
module Components
  class Base
    extend Forwardable
    include ActiveSupport::Callbacks
    include HM::Helpers::State
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    attr_reader :hm, :logger, :name, :config, :state

    define_callbacks :initialize

    def_delegator :hm, :logger, :logger
    def_delegator :hm, :config, :config

    def initialize(hm, default_state={})
      run_callbacks :initialize do
        @hm    = hm
        @state = default_state
        hm.components.push(self)
      end

      publish('event/device_added', {'component' => name, 'id' => id})
    end

    def name
      self.class.name.split('::').last.downcase
    end

    def id
      @id ||= "#{name}-#{SecureRandom.hex(3)}"
    end

    def self.setup(hm)
    end
  end
end
