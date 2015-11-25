require 'spec_helper'
require 'helpers/publisher'

describe 'HM::Helpers::Publisher' do
  class TestWithPublisherHelper
    attr_reader :hm
    include HM::Helpers::Publisher

    def initialize(hm)
      @hm = hm
    end

  end

  describe '#publish' do
    let(:hm) { double(:hm) }
    let(:test_with_publishser_helper) { TestWithPublisherHelper.new(hm) }

    it 'calls publish on the HomeMon instance' do
      expect( hm ).to receive(:publish).with('channel', 'message')

      test_with_publishser_helper.publish('channel', 'message')
    end
  end
end
