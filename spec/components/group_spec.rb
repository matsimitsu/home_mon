require 'spec_helper'
require 'core/component'
require 'components/group'

describe Components::Group do
  let(:hm) do
    double(
      :hm,
      :components => [],
      :publish    => true,
      :subscribe  => true,
      :component_config => {
        'group-1' => {
          'name' => 'Woonkamer',
          'members' => ['switch1', 'switch2']
        }
      }
    )
  end
  let(:initial_state) do
    {
      'name'    => 'Woonkamer',
      'members' => ['switch1', 'switch2'],
      'id'      => 'group-1',
      'power'   => 'off'
    }
  end
  let(:group) { Components::Group.new(hm, initial_state) }

  describe '.setup' do
    it 'returns a new group for each group found in the config' do
      expect( Components::Group ).to receive(:new).with(hm, initial_state)

      Components::Group.setup(hm)
    end
  end

  describe '#id' do
    it 'returns the id from attributes' do
      expect( group.id ).to eql('group-1')
    end
  end

  describe '#switch_on' do
    before { allow(group).to receive(:change_state) }

    it 'sends out an event for each member' do
      expect( group ).to receive(:publish).with('components/switch1/on', {})
      expect( group ).to receive(:publish).with('components/switch2/on', {})

    end

    it 'changes the state to on' do
      expect( group ).to receive(:change_state).with(:power => 'on')
    end

    after { group.switch_on }
  end

  describe '#switch_off' do
    before { allow(group).to receive(:change_state) }

    it 'sends out an event for each member' do
      expect( group ).to receive(:publish).with('components/switch1/off', {})
      expect( group ).to receive(:publish).with('components/switch2/off', {})
    end

    it 'changes the state to off' do
      expect( group ).to receive(:change_state).with(:power => 'off')
    end

    after { group.switch_off }
  end

  describe '#listen_for_changes' do

    it 'subscribes to changes for this group' do
      expect( group ).to receive(:subscribe).with('components/group/group-1/off', 'group-1', :switch_off)
      expect( group ).to receive(:subscribe).with('components/group/group-1/on', 'group-1', :switch_on)

      group.listen_for_changes
    end
  end
end
