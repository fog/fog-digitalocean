module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def update_record(name, id, rec={})
          update_options = {
            :type       => rec[:type],
          }
          %w(name data priority port weight).each do |fld|
            update_options[fld.to_sym] = rec[fld.to_sym] if rec[fld.to_sym]
          end

          encoded_body = Fog::JSON.encode(update_options)

          request(
            :expects => [201],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => "/v2/domains/#{name}/records/#{id}",
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def update_record(name, id, rec={})
          response        = Excon::Response.new
          response.status = 200

          updated = data[:domain_records][name].select{ |rec| rec['id'] == id }.last
          updated.merge!(rec)
          response.body = {
            "domain_record" => updated
          }

          response
        end
      end
    end
  end
end
