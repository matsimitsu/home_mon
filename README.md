# HomeMon

An event-driven home monitoring/automatisation system based on [MQTT](http://mqtt.org)

The goal is to build a system that responds to incoming events (light switch toggle, temperature change etc.)
by performing actions (turn lights on, dim lights, etc.).

It should be able to apply filters on actions, (e.g. only turn light on when someone's home)
and communicate all state changes back to the event system.

It's inspired by [Home Assistant](http://home-assistant.io), but converted to my own needs.
(React frontend instead of Polymer, Ruby background instead of Python and using MQTT as the event bus instead of a custom one.)

# Requirements

* Ruby (2.x)
* NPM for the frontend
* An MQTT event broker ([Mosquito](http://mosquitto.org)


# Installation

* Clone the repo
* Install the gems `bundle install`.
* Navigate to `/frontend`, run `npm`

# Run

* Start Mosquitto   `bundle exec foreman start`
* Run the server    `bundle exec ruby app.rb`
* Runt the frontend `cd frontend && gulp`



# Components

This application is made up of components that subscribe to the event bus and react to changes.

A component consists of at least one class method and one or more instance methods.
It also exposes a state for it's fields.

## Setup

Once a component is loaded, `self.setup` is called with the `HomeMonitor instance`.
In this setup phase you can generate zero or more instances of the component, based on configuration.

The HomeMonitor instance exposes the config `hm.config`. You can get the component specific config (if available) with `hm.component_config(component_name)` where `component_name` is a downcased version of the name. (e.g. Components::Lifx becomes 'lifx')

In the setup you can also subscribe to certain events to update your component when needed. For example we want to update the LIFX lights every 5 minutes (to detect new lights for example).

When creating a new instance, always pass the `HomeMonitor` instance.
``` ruby
def self.setup(hm)
  if hm.component_config('lifx') # Make sure we can activate this component
    self.subscribe_periodically(hm, {:minutes => 5}, :update)
  end

# Updates each Lifx bulb
def self.update
  api_key =  hm.component_config('lifx').get('api_key', nil)
  if api_key
    Lifx.get_bulbs(api_key).each do |bulb|
      new(hm, bulb.config)
    end
  end
end
```

## State
Each component instance should expose it's state with a `expose_state` method.

``` ruby
def expose_state
  {
    :state      => self.status,
    :brightness => self.brightness
  }
end
```

This state will be sent to the event bus on each state change.
(For example a light is turned on, or a new temperature metric is received)
Other components (including the frontend) can subscribe to these states to
display it, or trigger events based on it.

If you use the `update_state` method in a component, a new event will be published when the stage changes.

``` ruby
def foo
  set_state(:bar => true)
end
```

If you want to send an changed event regardless if the state has changed (values are the same)
you can pass `:force => true`.

``` ruby
def foo
  set_state(:bar => true, :force => true)
end

```
## Listen for changes

A component can listen for changes when `listen_for_changes` is defined, for example:


``` ruby
def listen_for_changes
  subscribe("switches/#{name}/off", name, :switch_off)
  subscribe("switches/#{name}/on", name, :switch_on)
end
```

Where `name` should always be unique per component.
If not given in the initializer, a name will be generated in the pattern `component name - random hex`
for example: 'lifx-abc123'

## Publish changes

A component can publish events by calling `publish`


``` ruby
def foo
  publish('channel/specific', {:foo => 'bar'}))
end

```

## Example
An example of a component:

``` ruby
module Components
  class Logger
    include HM::Helpers::Component
    include HM::Helpers::Subscriber
    include HM::Helpers::Publisher

    def self.setup(hm)
      new(hm).start_monitor if hm.component_config('logger')
    end

    def start_monitor
      subscribe('#', self.name) do |channel, message|
        logger.debug("Message received on #{channel}: #{message}")
      end
    end
  end
end
```
