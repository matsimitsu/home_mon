require 'spec_helper'
require 'helpers/state'

describe 'HM::Helpers::State' do
  class TestWithStateHelper
    include HM::Helpers::State

    def id; 'abc123'; end
  end

  let(:test_with_state_helper) { TestWithStateHelper.new }

  describe '#expose_state' do
    before do
      allow(test_with_state_helper).to receive(:state).and_return({'foo' => 'bar'})
    end

    it 'returns the internal state' do
      expect( test_with_state_helper.expose_state ).to eql({'foo' => 'bar'})
    end
  end

  describe '#change_state' do
    before do
      allow(test_with_state_helper).to receive(:state).and_return({'foo' => 'bar'})

      # Make sure we don't publish stuff
      allow(test_with_state_helper).to receive(:publish)
    end

    it 'merges the old state with the new' do
      expect( test_with_state_helper.change_state({'baz' => 'moo'}) ).to eql(
        {'foo' => 'bar', 'baz' => 'moo'}
      )

      expect( test_with_state_helper.expose_state ).to eql(
        {'foo' => 'bar', 'baz' => 'moo'}
      )
    end

    it 'publishes the new state when changed' do
      expect( test_with_state_helper ).to receive(:publish).with(
        'event/state_changed',
        {'foo' => 'bar', 'baz' => 'moo', 'id' => 'abc123'}
      )

      test_with_state_helper.change_state({'baz' => 'moo'})
    end

    context 'when state is not changed' do
      it 'does not merge the new state when changed' do
        expect( test_with_state_helper ).to receive(:publish)

        test_with_state_helper.change_state({'foo' => 'bar'})
      end

      context 'when forced change state' do
        it 'publishes the new state when changed' do
          expect( test_with_state_helper ).to receive(:publish).with(
            'event/state_changed',
            {'foo' => 'bar', 'id' => 'abc123'}
          )

          test_with_state_helper.change_state({'foo' => 'bar', :force => true})
        end
      end
    end
  end
end
