require 'rack'
require 'thin'

module Components
  class Webserver < Core::Component
    set_callback :initialize, :after, :start_webserver

    def self.setup(hm)
      if hm.component_config('webserver').present?
        new(hm, hm.component_config('webserver'))
      end
    end

    def start_webserver
      dir = File.join(hm.root, 'public')
      core = hm
      Thin::Server.start('0.0.0.0', state['port'], :signals => false) do
        map "/" do
          use Rack::Static, :urls => [""], :root => dir, :index => 'index.html'
          run lambda {|*|}
        end

        map '/api/events/trigger' do
          run Proc.new {|env|
            request = Rack::Request.new env
            if request.options?
              [
                200,
                {
                  'Access-Control-Allow-Origin' => '*',
                  'Access-Control-Allow-Methods' => 'POST, GET, OPTIONS',
                  'Access-Control-Allow-Headers' => 'Content-Type, Access-Control-Allow-Headers'
                },
                {}
              ]
            elsif request.post?
              hsh     = JSON.parse(request.body.read)
              core.publish(hsh['action'], hsh['params'])
              [202, {'Content-Type' => 'application/json', 'Access-Control-Allow-Origin' => '*'}, '']
            else
              [404, {}, {}]
            end
          }
        end

        map '/api/components' do
          run Proc.new {|env|
            hsh =  {}
            core.visible_components.each do |component|
              hsh[component.name] = [] unless hsh[component.name]
              hsh[component.name].push(component.expose_state)
            end
            json = JSON.generate(hsh)
            [200, {'Content-Type' => 'application/json', 'Access-Control-Allow-Origin' => '*'}, json]
          }
        end
      end
    end
  end
end
