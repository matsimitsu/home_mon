require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'em/mqtt'
require 'logger'
require 'securerandom'
require 'yaml'
require 'active_support/time'
require 'active_support/concern'
require 'json'
require 'rest_client'
require 'websocket-eventmachine-server'

module HM
  class Core

    attr_reader :logger, :root, :connection, :config, :subscriber
    attr_accessor :components

    def initialize(root)
      @root          = root
      @subscriber    = Subscriber.new
      @logger        = Logger.new(STDOUT)
      @config        = YAML.load_file(File.join(root, 'config', 'config.yml'))
      @components    = []
      require_helpers
    end

    def setup_components
      Dir.glob(File.join(root, 'components', '**', '*.rb')).each do |filename|
        require filename
        klass = "Components::#{File.basename(filename, '.rb').classify}".constantize
        klass.setup(self)
      end
    end

    def require_helpers
      Dir.glob(File.join(root, 'helpers', '**', '*.rb'), &method(:require))
    end

    def start
      EventMachine::error_handler { |e| puts "#{e}: #{e.backtrace.first}" }

      EventMachine.run do
        @connection = EventMachine::MQTT::ClientConnection.connect('localhost')

        @connection.subscribe('#')
        @connection.receive_callback do |message|
          channel = message.topic
          payload = message.payload

          @subscriber.matching_subscriptions(channel).each do |subscription|
            subscription.block.call(channel, payload)
          end
        end
        setup_components
        @connection.publish('core/start', nil)
      end
    end

    def publish(channel, message)
      @connection.publish(channel, message)
    end

    def subscribe(channel, id, &block)
      logger.debug("#{id} subscribing to #{channel}")
      subscriber.subscribe(channel, id, &block)
    end

    def unsubscribe(channel, id)
      logger.debug("#{id} unsubscribing from #{channel}")
      subscriber.unsubscribe(channel, id)
    end
  end

end

require 'core/subscriber'
require 'core/subscription'
