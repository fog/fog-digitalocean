module Fog
  module DNS
    class DigitalOcean
      class Real
        def list_domains(filters = {})
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "v2/domains",
            :query   => filters
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_domains(filters = {})
          response        = Excon::Response.new
          response.status = 200
          response.body   = {
              "domains" => data[:domains],
              "links" => {},
              "meta" => {
                  "total" => data[:domains].count
              }
          }
          response
        end
      end
    end
  end
end
