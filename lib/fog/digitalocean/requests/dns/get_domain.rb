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
        alias :get_zone :get_domain
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def get_domain(name)
          response        = Excon::Response.new

          domains = data[:domains].select{ |dom| dom['name'].eql?(name) }
          if domains.size > 0
            response.status = 200
            response.body = {
                'domain' => domains.last
            }
          else
            response.status = 404
            response.body = {
                'id'      => 'not_found',
                'message' => 'The resource you were accessing could not be found.'
            }
            raise Fog::Errors::NotFound.new(response.body['message'])
          end

          response
        end
        alias :get_zone :get_domain
      end
    end
  end
end
