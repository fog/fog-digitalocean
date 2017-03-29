module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def create_record(name, rec={})
          create_options = {
            :type       => rec[:type],
          }
          %w(name data priority port weight).each do |fld|
            create_options[fld.to_sym] = rec[fld.to_sym] if rec[fld.to_sym]
          end

          encoded_body = Fog::JSON.encode(create_options)

          request(
            :expects => [201],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => "/v2/domains/#{name}/records",
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def create_record(name, rec={})
          response        = Excon::Response.new
          response.status = 200

          data[:domain_records][name] << rec.dup
          data[:domain_records][name].last['id'] = Fog::Mock.random_numbers(8).to_i
          response.body = {
            "domain_record" => data[:domain_records][name].last
          }

          response
        end
      end
    end
  end
end
