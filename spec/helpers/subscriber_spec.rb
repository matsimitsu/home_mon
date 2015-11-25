require 'spec_helper'
require 'helpers/subscriber'

describe 'HM::Helpers::Subscriber' do
  class TestWithSubscriberHelper
    attr_reader :hm, :called
    include HM::Helpers::Subscriber

    def initialize(hm)
      @hm     = hm
      @called = false
    end

    def callback(channel, message)
      @called = true
    end
  end

  describe 'class methods' do
    describe '.subscribe' do
      let(:hm) { double(:hm) }

      it 'subscribes to a channel and receives messages' do
        expect( hm ).to receive(:subscribe).with('channel', 'id')
                                           .and_yield('channel', 'message')

        TestWithSubscriberHelper.subscribe(hm, 'channel', 'id') do |channel, message|
          expect( channel ).to eql('channel')
          expect( message ).to eql('message')
        end
      end
    end

    describe '.subscribe_once' do
      let(:hm) { double(:hm) }

      it 'subscribes to a channel and receives messages, then unsubscribes' do
        expect( hm ).to receive(:subscribe).with('channel', 'id')
                                           .and_yield('channel', 'message')

        expect( hm ).to receive(:unsubscribe).with('channel', 'id')

        TestWithSubscriberHelper.subscribe_once(hm, 'channel', 'id') do |channel, message|
          expect( channel ).to eql('channel')
          expect( message ).to eql('message')
        end

      end
    end

    describe '.subscribe_timestamp' do
      let(:hm)      { double(:hm) }
      let(:time)    { Time.parse('10-10-2010 10:00:00 UTC') }
      let(:message) { {'time' => time.to_s} }

      before { allow(SecureRandom).to receive(:hex).and_return('123')}

      it 'subscribes to timer/tick and waits for a certain time, then unsubscribes' do
        @called = false
        expect( hm ).to receive(:subscribe).with('timer/tick', 'timer-123')
                                           .and_yield('timer/tick', message)

        expect( hm ).to receive(:unsubscribe).with('timer/tick', 'timer-123')

        TestWithSubscriberHelper.subscribe_timestamp(hm, time) do |channel, message|
          expect( channel ).to eql('timer/tick')
          expect( message ).to eql(message)
          @called = true
        end

        expect( @called ).to be_truthy
      end

      context 'when timestamps dont match' do
        let(:time)    { Time.parse('10-10-2010 10:00:00 UTC') }
        let(:message) { {'time' => time.advance(:minutes => -1).to_s} }

        it 'subscribes to timer/tick and waits for a certain time' do
          @called = false

          expect( hm ).to receive(:subscribe).with('timer/tick', 'timer-123')
                                             .and_yield('timer/tick', message)

          # It should not unsubscribe, because the time hasn't been reached
          expect( hm ).to_not receive(:unsubscribe).with('timer/tick', 'timer-123')

          TestWithSubscriberHelper.subscribe_timestamp(hm, time) do |channel, message|
            expect( channel ).to eql('timer/tick')
            expect( message ).to eql(message)
            @called = true
          end

          # It should not have been called
          expect( @called ).to be_falsy
        end
      end
    end

  end

  describe 'instance methods' do
    let(:hm) { double(:hm) }
    let(:test_with_helper) { TestWithSubscriberHelper.new(hm) }

    describe '#subscribe' do
      it 'subscribes to a channel on the class, and yields the result' do
        @called = false
        expect( TestWithSubscriberHelper ).to receive(:subscribe)
                                                .with(hm, 'channel', 'id')
                                                .and_yield('channel', 'message')

        test_with_helper.subscribe('channel', 'id') do |channel, message|
          expect( channel ).to eql('channel')
          expect( message ).to eql('message')
          @called = true
        end

        expect( @called ).to be_truthy
      end

      context 'with callback method' do
        it 'subscribes to a channel on the class, and calls the given callback' do

          expect( TestWithSubscriberHelper ).to receive(:subscribe)
                                                  .with(hm, 'channel', 'id')
                                                  .and_yield('channel', 'message')

          test_with_helper.subscribe('channel', 'id', :callback)

          expect( test_with_helper.called ).to be_truthy
        end
      end
    end

    describe '#subscribe_once' do
      it 'subscribes to a channel on the class, and yields the result' do
        @called = false
        expect( TestWithSubscriberHelper ).to receive(:subscribe_once)
                                                .with(hm, 'channel', 'id')
                                                .and_yield('channel', 'message')

        test_with_helper.subscribe_once('channel', 'id') do |channel, message|
          expect( channel ).to eql('channel')
          expect( message ).to eql('message')
          @called = true
        end

        expect( @called ).to be_truthy
      end

      context 'with callback method' do
        it 'subscribes to a channel on the class, and calls the given callback' do

          expect( TestWithSubscriberHelper ).to receive(:subscribe_once)
                                                  .with(hm, 'channel', 'id')
                                                  .and_yield('channel', 'message')

          test_with_helper.subscribe_once('channel', 'id', :callback)

          expect( test_with_helper.called ).to be_truthy
        end
      end
    end

    describe '#subscribe_timestamp' do
      let(:time)    { Time.parse('10-10-2010 10:00:00 UTC') }

      it 'subscribes to a channel on the class, and yields the result' do
        @called = false
        expect( TestWithSubscriberHelper ).to receive(:subscribe_timestamp)
                                                .with(hm, time)
                                                .and_yield('channel', 'message')

        test_with_helper.subscribe_timestamp(time) do |channel, message|
          expect( channel ).to eql('channel')
          expect( message ).to eql('message')
          @called = true
        end

        expect( @called ).to be_truthy
      end

      context 'with callback method' do
        it 'subscribes to a channel on the class, and calls the given callback' do

          expect( TestWithSubscriberHelper ).to receive(:subscribe_timestamp)
                                                  .with(hm, time)
                                                  .and_yield('channel', 'message')

          test_with_helper.subscribe_timestamp(time, :callback)

          expect( test_with_helper.called ).to be_truthy
        end
      end
    end
  end
end
