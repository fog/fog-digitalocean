require 'active_support/core_ext/hash/indifferent_access'

module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def update_record(name, rec={})
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
            :path    => "/v2/domains/#{name}/records/#{rec[:id]}",
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def update_record(name, rec={})
          response        = Excon::Response.new
          response.status = 200

          updated = data[:domain_records][name].select{ |rec| rec['id'] == rec[:id] }.last.with_indifferent_access
          updated[:id] = Fog::Mock.random_numbers(8).to_i
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
