#!/usr/bin/env ruby
require 'rubygems'
require 'bundler'
Bundler.setup(:default)
require 'em/mqtt'
require 'em-serialport'
require 'json'

EM.run do
  mqqt   = EventMachine::MQTT::ClientConnection.connect('127.0.0.1')
  serial = EventMachine.open_serial('/dev/ttyACM0', 9600, 8, 1, 0)
  serial.on_data do |data|
    kind = /[a-z]/.match(data).to_s
    case kind
      when 'w'
        channel = 'metrics/water'
      when 'e'
        channel = 'metrics/electricity'
      when 'g'
        channel = 'metrics/gas'
    end
    mqqt.publish(channel, JSON.generate({:value => 1})) if channel && channel.length > 0
  end
end
