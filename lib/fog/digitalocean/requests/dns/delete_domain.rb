module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real
        def delete_domain(id)
          id = id.with_indifferent_access['domain'] if id.is_a?(Hash)
          request(
            :expects => [204],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'DELETE',
            :path    => "/v2/domains/#{id}",
          )
        end
        alias :delete_zone :delete_domain
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def delete_domain(id)
          id = id.with_indifferent_access['domain'] if id.is_a?(Hash)
          data[:domain_records].delete(id)
          data[:domains].select! do |key|
            key['name'] != id
          end

          response        = Excon::Response.new
          response.status = 204
          response
        end
        alias :delete_zone :delete_domain
      end
    end
  end
end
