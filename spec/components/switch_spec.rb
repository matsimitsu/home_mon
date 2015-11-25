require 'spec_helper'
require 'components/base'
require 'components/switch'

describe Components::Switch do
  let(:hm) do
    double(
      :hm,
      :components => [],
      :publish    => true,
      :subscribe  => true,
    )
  end
  let(:switch) { Components::Switch.new(hm) }

  describe '#listen_for_changes' do
    before { allow(switch).to receive(:id).and_return('switch-1') }
    it 'subscribes to changes for this switch' do
      expect( switch ).to receive(:subscribe).with('components/switch/switch-1/off', 'switch-1', :switch_off)
      expect( switch ).to receive(:subscribe).with('components/switch/switch-1/on', 'switch-1', :switch_on)

      switch.listen_for_changes
    end
  end
end
