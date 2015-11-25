require 'spec_helper'

describe HM::Core do
  let(:root_path) { File.join(File.expand_path(File.dirname(__FILE__)), '/../..') }
  let(:core)      { HM::Core.new(root_path) }

  describe '#component_config' do
    let(:config) { {'components' => {'lifx' => {'name' => 'lifx'}}} }

    before  { core.instance_variable_set(:@config, config) }

    it 'returns component config when present' do
      expect( core.component_config('lifx') ).to eql({'name' => 'lifx'})
    end

    context 'when config is missing' do
      let(:config) { {} }

      it 'returns an empty hash' do
        expect( core.component_config('lifx') ).to eql({})
      end
    end
  end

  describe '#component_config?' do
    let(:config) { {'components' => {'lifx' => {'name' => 'lifx'}}} }

    before  { core.instance_variable_set(:@config, config) }

    it 'returns true when component config is present' do
      expect( core.component_config?('lifx') ).to be_truthy
    end

    context 'when config is missing' do
      let(:config) { {} }

      it 'returns an empty hash' do
        expect( core.component_config?('lifx') ).to be_falsy
      end
    end
  end

  describe '#setup_components' do
    let(:component) { double(:component, :setup => true) }

    before do
      allow(Dir).to  receive(:glob).and_return(['path/to/file.rb'])
      allow(core).to receive(:require).and_return(true)

      allow_any_instance_of(String).to receive(:constantize).and_return(component)
    end

    it 'loads component from disk and requires them' do
      expect( core ).to receive(:require).with('path/to/file.rb')
    end

    it 'constantizes the component and calls setup' do
      expect_any_instance_of( String ).to receive(:constantize)
      expect( component ).to receive(:setup)

    end

    after { core.setup_components }
  end

  describe '#require_helpers' do
    it 'requires the files found in the helpers dir' do
      path = File.join(root_path, '/helpers/**/*.rb')
      expect( Dir ).to receive(:glob).with(path)
                                     .and_return(['/path/to/helper.rb'])
                                     .at_least(1)
                                     .times
    end

    after { core.require_helpers }
  end

  describe '#run' do
    let(:json)         { JSON.generate({'foo' => 'bar'}) }
    let(:topic)        { 'event/new' }
    let(:message)      { double(:message, :topic => topic, :payload => json) }
    let(:connection) do
      double(:connection, :subscribe => true, :publish => true)
    end

    before do
      # Stub MQTT connection
      allow(EventMachine::MQTT::ClientConnection).to receive(:connect)
                                                      .and_return(connection)

      # Stub eventmachine MQTT callback
      allow(connection).to receive(:receive_callback).and_yield(message)

      # Stub setup_components
      allow(core).to receive(:setup_components)
    end

    it 'connects to mqtt' do
      expect(EventMachine::MQTT::ClientConnection).to receive(:connect)
                                                        .with('localhost')
                                                        .and_return(connection)
    end

    it 'connects subscribes to "#"' do
      expect( connection ).to receive(:subscribe).with('#')
    end

    it 'listens for messages' do
      expect( connection ).to receive(:receive_callback)
    end

    it 'processes received message' do
      expect( core ).to receive(:process_message).with(message)
    end

    it 'sets up the components' do
      expect( core ).to receive(:setup_components)
    end

    it 'lets other components know its done' do
      expect( connection ).to receive(:publish).with('core/start', {})
    end

    after { core.run }
  end

  describe '#process_message' do
    let(:json)         { JSON.generate({'foo' => 'bar'}) }
    let(:topic)        { 'event/new' }
    let(:message)      { double(:message, :topic => topic, :payload => json) }
    let(:subscriber)   { double(:subscriber) }

    before do
      allow(core).to receive(:subscriber).and_return(subscriber)
    end

    it 'should decode the json and pass the message to the subscriber' do
      expect( subscriber ).to receive(:process_channel_payload)
                                .with('event/new', {'foo' => 'bar'})
    end

    after { core.process_message(message) }
  end

  describe '#publish' do
    let(:channel)    { 'foo/bar' }
    let(:message)    { {'foo' => 'bar'} }
    let(:connection) { double(:connection) }

    before { allow(core).to receive(:connection).and_return(connection) }

    it 'encodes the message to JSON and sends it over the connection' do
      expect( connection ).to receive(:publish).with('foo/bar', '{"foo":"bar"}')
    end

    after { core.publish(channel, message) }
  end

  describe '#subscribe' do
    let(:channel)    { 'foo/bar' }
    let(:id)         { 'abc-123' }
    let(:block)      { double(:block) }

    # Silence the logger
    before { allow(core.logger).to receive(:debug) }

    it 'calls subscribe on subscriber with params' do
      expect( core.subscriber ).to receive(:subscribe).with('foo/bar', 'abc-123')
    end

    after { core.subscribe(channel, id) { |a,b| } }
  end

  describe '#unsubscribe' do
    let(:channel)    { 'foo/bar' }
    let(:id)         { 'abc-123' }

    # Silence the logger
    before { allow(core.logger).to receive(:debug) }

    it 'calls unsubscribe on subscriber with params' do
      expect( core.subscriber ).to receive(:unsubscribe).with('foo/bar', 'abc-123')
    end

    after { core.unsubscribe(channel, id) }
  end
end
