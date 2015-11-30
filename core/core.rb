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
require 'erb'

module HM
  class Core

    attr_reader :logger, :root, :connection, :config, :subscriber, :mutex
    attr_accessor :components

    def initialize(root)
      @root          = root
      @subscriber    = Subscriber.new
      @logger        = Logger.new(STDOUT)
      @config        = load_config
      @components    = []
      @connection    = nil
    end

    def load_config
      YAML::load(ERB.new(IO.read(File.join(root, 'config', 'config.yml'))).result)
    end

    # Convenience method that returns the component config
    def component_config(component_name)
      @config.fetch('components', {}).fetch(component_name, {})
    end

    # Convenience method that checks if the component has a config
    def component_config?(component_name)
      component_config(component_name).any?
    end

    # Globs components from directory and requires them
    def require_components
      Dir.glob(File.join(root, 'components', '**', '*.rb')).each do |filename|
        load filename
      end
    end

    # Globs components from directory and calls 'setup' on the class
    def setup_components
      Dir.glob(File.join(root, 'components', '**', '*.rb')).each do |filename|
        klass = "Components::#{File.basename(filename, '.rb').classify}".constantize
        klass.setup(self)
      end
    end

    def components_state
      components.map { |c| c.expose_state }
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
      EventMachine.stop
    end

    # Called from the eventmachine loop, here so we can test it :)
    def run
      require_components
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
      logger.debug "Publishing #{message.inspect} to #{channel}"
      connection.publish(channel, JSON.generate(message || {}))
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
require 'core/component'
