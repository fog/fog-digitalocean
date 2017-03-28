module Fog
  module DNS
    class DigitalOcean
      class Real
        def list_records(name, filters = {})
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "v2/domains/#{name}/records",
            :query   => filters
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_records(name, filters = {})
          response        = Excon::Response.new
          response.status = 200
          response.body = {
            "domain_records" => data[:domain_records][name],
            "links" => {},
            "meta" => {
                "total" => data[:domain_records][name].count
            }
          }
          response
        end
      end
    end
  end
end
