module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def get_record(name, id)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "/v2/domains/#{name}/records/#{id}",
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def get_record(name, id)
          response        = Excon::Response.new
          response.status = 200

          response.body = {
              "domain_record" => data[:domain_records][name].last
          }

          response
        end
      end
    end
  end
end
