$:.unshift File.dirname(__FILE__)
require 'core/core'

hm = HM::Core.new(File.expand_path File.dirname(__FILE__))
hm.start
