$:.unshift File.dirname(__FILE__)+'/core'

require 'core'

hm = HM::Core.new(File.expand_path File.dirname(__FILE__))
hm.start
