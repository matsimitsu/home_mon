require 'spec_helper'
require 'components/base'
require 'components/timer'

describe Components::Timer do
  let(:hm)    { double(:hm, :components => [], :publish => true) }
  let(:timer) { Components::Timer.new(hm) }
  let(:time)  { Time.parse('10-10-2010 10:00:00 UTC') }

  describe '#start_timer' do
    around do |sample|
      Timecop.freeze(time) { sample.run }
    end

    before do
      allow(EventMachine::PeriodicTimer).to receive(:new).and_yield()
    end

    it 'runs an event machine timer' do
      expect( EventMachine::PeriodicTimer ).to receive(:new).with(10).and_yield()
    end

    it 'publishes a message when time has changed' do
      rounded = time.change(:sec => 0, :usec => 0).iso8601
      expect( hm ).to receive(:publish).with('timer/tick', {:time => rounded})
    end

    after { timer.start_timer }
  end
end
