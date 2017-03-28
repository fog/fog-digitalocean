module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def create_domain(name, ip_address)
          create_options = {
            :name       => name,
            :ip_address => ip_address,
          }

          encoded_body = Fog::JSON.encode(create_options)

          request(
            :expects => [201],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => '/v2/domains',
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def create_domain(name, ip_address)
          response        = Excon::Response.new
          response.status = 200

          response.body ={
            'domain' => data[:domains].last
          }

          response
        end
      end
    end
  end
end
