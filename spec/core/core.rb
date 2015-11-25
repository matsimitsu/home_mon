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
end
