require 'spec_helper'
require 'core/component'
require 'components/sun'

describe Components::Sun do
  let(:hm)    do
    double(
      :hm,
      :components => [],
      :publish    => true,
      :subscribe  => true,
      :config     => {'lat' => 52.0263009, 'lng' => 5.5544309}
    )
  end
  let(:sun)   { Components::Sun.new(hm) }
  let(:time)  { Time.parse('10-10-2010 10:00:00 UTC') }

  around do |sample|
    Timecop.travel(time) { sample.run }
  end

  it 'should override the id' do
    expect( sun.id ).to eql('sun')
  end

  it 'should return the lat' do
    expect( sun.lat ).to eql(52.0263009)
  end

  it 'should return the lng' do
    expect( sun.lng ).to eql(5.5544309)
  end

  describe '#expose_state' do
    it 'should return now, sunset, sunrise and change' do
      expect( JSON.generate(sun.expose_state) ).to eql(JSON.generate({
        :now          => 'day',
        :next_sunrise => Time.parse('2010-10-11 05:54:50 UTC'),
        :next_sunset  => Time.parse('2010-10-10 16:55:38 UTC'),
        :next_change  => Time.parse('2010-10-10 16:55:38 UTC')
      }))
    end
  end

  describe '#now' do
    it 'returns day, when its day' do
      expect( sun.now ).to eql('day')
    end

    context 'after sunset' do
      let(:time) { Time.parse('10-10-2010 17:00:00 UTC') }

      it 'returns night' do
        expect( sun.now ).to eql('night')
      end
    end

    context 'before sunrise' do
      let(:time) { Time.parse('10-10-2010 05:30:00 UTC') }

      it 'returns night' do
        expect( sun.now ).to eql('night')
      end
    end
  end

  describe '#next_sunset' do
    it 'returns the next sunset' do
      expect( sun.next_sunset.to_s )
        .to eql(Time.parse('2010-10-10 16:55:38 UTC').to_s)
    end

    context 'when the sun is already set for today' do
      let(:time) { Time.parse('10-10-2010 17:00:00 UTC') }

      it 'returns the next sunset (of tomorrow)' do
        expect( sun.next_sunset.to_s )
          .to eql(Time.parse('2010-10-11 16:53:23 UTC').to_s)
      end
    end
  end

  describe '#next_sunrise' do
    it 'returns the next sunrise' do
      expect( sun.next_sunrise.to_s )
        .to eql(Time.parse('2010-10-11 05:54:50 UTC').to_s)
    end

    context 'when the sun has already risen for today' do
      let(:time) { Time.parse('10-10-2010 20:00:00 UTC') }

      it 'returns the next sunset (of tomorrow)' do
        expect( sun.next_sunrise.to_s )
          .to eql(Time.parse('2010-10-11 05:54:50 UTC').to_s)
      end
    end
  end

  describe 'next_change' do
    it 'returns the next first change' do
      expect( sun.next_change.to_s )
        .to eql(Time.parse('2010-10-10 16:55:38 UTC').to_s)
    end

    context 'when the sun has not yet risen for today' do
      let(:time) { Time.parse('10-10-2010 01:00:00 UTC') }

      it 'returns the next sunset (of tomorrow)' do
        expect( sun.next_sunrise.to_s )
          .to eql(Time.parse('2010-10-10 05:53:08 UTC').to_s)
      end
    end
  end

  describe '#update' do
    before { allow(sun).to receive(:next_change).and_return(time) }

    it 'updates the state with the new times' do
      expect( sun ).to receive(:change_state).with(sun.expose_state)
    end

    it 'subscribes to the next change' do
      expect( sun ).to receive(:subscribe_timestamp)
                        .with(time.advance(:seconds => 1), :update)
    end

    after { sun.update }
  end
end
