module Automate
  module Triggers
    class Base
      extend Forwardable
      include ActiveSupport::Callbacks
      include HM::Helpers::State
      include HM::Helpers::Subscriber
      include HM::Helpers::Publisher

      attr_reader :hm, :attributes, :automation
      define_callbacks :initialize

      def_delegator :automation, :id, :id
      def_delegator :automation, :name, :name

      def_delegator :hm, :logger, :logger
      def_delegator :hm, :config, :config

      def initialize(hm, automation, attributes={})
        run_callbacks :initialize do
          @hm         = hm
          @automation = automation
          @attributes = attributes
        end
      end
    end
  end
end
require 'automate/triggers/timer'
