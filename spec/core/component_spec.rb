require 'spec_helper'
require 'core/component'

describe Core::Component do
  let(:hm)    { double(:hm, :components => [], :publish => true) }
  let(:state) { {'foo' => 'bar'} }
  let(:base)  { Core::Component.new(hm, state) }

  # Make SecureRandom a little less random
  before { allow(SecureRandom).to receive(:hex).and_return('abc123') }

  describe '#initialize' do
    it 'adds itself to the HM components list' do
      expect( hm.components ).to receive(:push).with(base)

      base.send(:initialize, hm, {})
    end

    it 'sets the given state' do
      expect( base.state ).to eql({'foo' => 'bar'})
    end

    it 'publishes itself to event/device_added' do
      expect( hm ).to receive(:publish).with(
        'event/device_added',
        {'component' => 'base', 'id' => 'base-abc123'}
      )

      base.send(:initialize, hm, {})
    end
  end

  describe '#name' do
    it 'returns the class name' do
      expect( base.name ).to eql('base')
    end
  end

  describe '#id' do
    it 'returns a random id' do
      expect( base.id ).to eql('base-abc123')
      expect( base.id ).to eql('base-abc123')
    end
  end
end
