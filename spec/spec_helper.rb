$:.unshift File.dirname(__FILE__)+'/..'

require 'core/core'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
