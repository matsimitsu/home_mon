require 'spec_helper'

describe HM::Subscription do
  let(:channel)      { 'foo/bar' }
  let(:id)           { double(:id) }
  let(:block)        { double(:block) }
  let(:subscription) { HM::Subscription.new(channel, id, block) }

  describe '#initialize' do
    it 'sets the channel, reader and block' do
      expect( subscription.channel ).to eql(channel)
      expect( subscription.id      ).to eql(id)
      expect( subscription.block   ).to eql(block)
    end
  end

  describe 'match_channel?' do
    context 'when subscribed to all channels' do
      let(:channel) { '#' }

      it 'returns true if channel matches #' do
        expect( subscription.match_channel?('foo/bar') ).to be_truthy
      end
    end

    it 'returns true if channel matches the exact channel' do
      expect( subscription.match_channel?('foo/bar') ).to be_truthy
    end

    it 'returns true if channel matches the wildcard' do
      expect( subscription.match_channel?('foo/*') ).to be_truthy
    end

    it 'returns false if channel does not match' do
      expect( subscription.match_channel?('banana') ).to be_falsy
    end

    it 'returns false if channel does not match wildcard' do
      expect( subscription.match_channel?('bar/*') ).to be_falsy
    end

  end
end
