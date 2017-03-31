module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def delete_record(name, id)
          id = id.with_indifferent_access['id'] if id.is_a?(Hash)
          request(
            :expects => [204],
            :method  => 'DELETE',
            :path    => "/v2/domains/#{name}/records/#{id}",
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def delete_record(name, id)
          id = id.with_indifferent_access['id'] if id.is_a?(Hash)
          response        = Excon::Response.new
          response.status = 204

          data[:domain_records][name].select!{ |rec| rec['id'] != id }

          response.body = {}

          response
        end
      end
    end
  end
end
