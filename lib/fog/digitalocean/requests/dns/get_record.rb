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
          id = id['id'] if id.is_a?(Hash)
          response        = Excon::Response.new

          recs = data[:domain_records][name].select { |rec| rec['id'] == id }
          if recs.size > 0
            response.status = 200
            response.body = {
                "domain_record" => recs.last
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
      end
    end
  end
end
