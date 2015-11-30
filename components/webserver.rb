require 'rack'
require 'thin'

module Components
  class Webserver < Core::Component
    set_callback :initialize, :after, :start_webserver

    def self.setup(hm)
      if hm.component_config('webserver')
        new(hm, hm.component_config('webserver'))
      end
    end

    def start_webserver
      dir = File.join(hm.root, 'public')
      Thin::Server.start('0.0.0.0', state['port'], :signals => false) do
        map "/" do
          use Rack::Static, :urls => [""], :root => dir, :index => 'index.html'
          run lambda {|*|}
        end
      end
    end
  end
end