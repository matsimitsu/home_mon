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
* An MQTT event broker ((Mosquito)[mosquitto.org])


# Installation

* Clone the repo
* Install the gems `bundle install`.
* Navigate to `/frontend`, run `npm`

# Run

* Start Mosquitto   `bundle exec foreman start`
* Run the server    `bundle exec ruby app.rb`
* Runt the frontend `cd frontend && gulp`
