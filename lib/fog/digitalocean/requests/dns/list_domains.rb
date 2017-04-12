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
        alias :list_zones :list_domains
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_domains(filters = {})
          response        = Excon::Response.new
          raise Fog::Errors::NotFound response.body['message'] unless data[:domains] && data[:domains].count > 0

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
        alias :list_zones :list_domains
      end
    end
  end
end
