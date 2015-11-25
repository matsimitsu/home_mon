require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'em/mqtt'
require 'logger'
require 'securerandom'
require 'yaml'
require 'active_support/time'
require 'active_support/concern'
require 'active_support/callbacks'
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
      @connection    = nil
    end

    # Convenience method that returns the component config
    def component_config(component_name)
      @config.fetch('components', {}).fetch(component_name, {})
    end

    # Convenience method that checks if the component has a config
    def component_config?(component_name)
      component_config(component_name).any?
    end

    # Globs components from directory, requires them
    # and calls 'setup' on the class
    def setup_components
      Dir.glob(File.join(root, 'components', '**', '*.rb')).each do |filename|
        require filename
        klass = "Components::#{File.basename(filename, '.rb').classify}".constantize
        klass.setup(self)
      end
    end

    # Runs the main loop
    def start
      EventMachine.epoll
      EventMachine::error_handler { |e| puts "#{e}: #{e.backtrace}" }
      trap("TERM") { stop }
      trap("INT")  { stop }
      # Run eventmachine loop
      EventMachine.run do
        run
      end
    end

    def stop
      logger.info("Terminating")
      EventMachine.stop
    end

    # Called from the eventmachine loop, here so we can test it :)
    def run
      @connection = EventMachine::MQTT::ClientConnection.connect('localhost')

      # Subscribe to the 'all' channel and process each incoming message
      @connection.subscribe('#')
      @connection.receive_callback do |message|
        process_message(message)
      end

      # After connection is present, load the components
      # (some depend on connection beeing there)
      setup_components

      # Publish a start message, so components can start doing their thing
      @connection.publish('core/start', {})
    end

    # Decodes the given message and calls any subscribers that match the channel
    def process_message(message)
      channel = message.topic
      payload = message.payload.present? ? JSON.parse(message.payload) : {}

      subscriber.process_channel_payload(channel, payload)
    end

    # Encodes the message and publishes it to the given channel
    def publish(channel, message={})
      connection.publish(channel, JSON.generate(message))
    end

    # Adds subscriber by id for the given channel
    def subscribe(channel, id, &block)
      logger.debug("#{id} subscribing to #{channel}")
      subscriber.subscribe(channel, id, &block)
    end

    # Unsubscribes subscriber by id from given channel
    def unsubscribe(channel, id)
      logger.debug("#{id} unsubscribing from #{channel}")
      subscriber.unsubscribe(channel, id)
    end
  end

end

require 'core/subscriber'
require 'core/subscription'
