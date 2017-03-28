module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def get_domain(name)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "/v2/domains/#{name}",
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def get_domain(name)
          response        = Excon::Response.new
          response.status = 200

          response.body = {
            'domain' => data[:domains].select{ |dom| dom['name'].eql?(name) }.last
          }

          response
        end
      end
    end
  end
end
