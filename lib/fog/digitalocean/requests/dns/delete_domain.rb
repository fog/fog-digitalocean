module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real
        def delete_domain(id)
          request(
            :expects => [204],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'DELETE',
            :path    => "/v2/domains/#{id}",
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def delete_domain(id)
          self.data[:domains].select! do |key|
            key["name"] != id
          end

          response        = Excon::Response.new
          response.status = 204
          response
        end
      end
    end
  end
end
