require 'spec_helper'

describe HM::Subscriber do
  let(:subscriber) { HM::Subscriber.new }

  describe '#subscribe' do
    let(:channel)      { 'foo/bar' }
    let(:id)           { double(:id) }
    let(:block)        { lambda { |a| a } }
    let(:subscription) { double(:subscription) }

    before { allow(HM::Subscription).to receive(:new).and_return(subscription) }

    it 'creates a new subscription from the arguments' do
      expect( HM::Subscription ).to receive(:new).with(channel, id, block)
                                            .and_return(subscription)

      subscriber.subscribe(channel, id, &block)
    end

    it 'adds the subscription to the subscriptions array' do
      subscriber.subscribe(channel, id, &block)

      expect( subscriber.subscriptions ).to include(subscription)
    end
  end

  describe '#unsubscribe' do
    let(:subscription) do
      double(:subscription, :id => 'sun', :channel => 'time/tick')
    end

    before { subscriber.instance_variable_set(:@subscriptions, [subscription]) }

    it 'removes subscription when given id and channel match' do
      expect{
        subscriber.unsubscribe('time/tick', 'sun')
      }.to change(subscriber, :subscriptions).from([subscription]).to([])
    end

    context 'when channel does not match' do
      it 'does not remove the subscription' do
        expect{
          subscriber.unsubscribe('event/new', 'sun')
        }.to_not change(subscriber, :subscriptions)
      end
    end

    context 'when id does not match' do
      it 'does not remove the subscription' do
        expect{
          subscriber.unsubscribe('time/tick', 'moon')
        }.to_not change(subscriber, :subscriptions)
      end
    end
  end

  describe '#matching_subscriptions' do
    let(:match_channel) { true }
    let(:subscription) do
      double(:subscription, :match_channel? => match_channel)
    end

    before { subscriber.instance_variable_set(:@subscriptions, [subscription]) }

    it 'returns matching subscriptions' do
      expect( subscriber.matching_subscriptions('time/tick') ).to eql([subscription])
    end

    context 'when subscriptions do not match' do
      let(:match_channel) { false }

      it 'returns any subscriptions' do
        expect( subscriber.matching_subscriptions('time/tick') ).to be_empty
      end
    end
  end

  describe '#process_channel_payload' do
    let(:channel)      { 'foo/bar' }
    let(:payload)      { {'foo' => 'bar'} }
    let(:block)        { double(:block) }
    let(:subscription) { double(:block => block) }

    before do
      allow(subscriber).to receive(:matching_subscriptions)
                            .and_return([subscription])
    end

    it 'calls the block for matching subscriptions' do
      expect( block ).to receive(:call).with(channel, payload)
    end

    after { subscriber.process_channel_payload(channel, payload)}
  end

end
