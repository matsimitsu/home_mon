$:.unshift File.dirname(__FILE__)+'/..'
require 'timecop'
require 'core/core'

RSpec.configure do |config|
  config.mock_with :rspec
end
