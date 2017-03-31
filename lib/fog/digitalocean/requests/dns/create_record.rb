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
          if rec.with_indifferent_access[:type] =~ /^A/
            if rec.with_indifferent_access[:data] !~ /^[0-9]+/
              response.status = 422
              response.body = {
                  "id" => "unprocessable_entity",
                  "message" => "Data needs to in an IP address"
              }
            else
              if rec.with_indifferent_access[:type] =~ /^AA/
                if rec.with_indifferent_access[:data] !~ /:/
                  response.status = 422
                  response.body = {
                      "id" => "unprocessable_entity",
                      "message" => "IP address did not match IPv6 format (e.g. 2001:db8::ff00:42:8329)."
                  }
                else
                  response.status = 200
                end
              else
                response.status = 200
              end
            end
          elsif rec.with_indifferent_access[:data] !~ /\.$/
            response.status = 422
            response.body = {
                "id" => "unprocessable_entity",
                "message" => "Data needs to end with a dot (.)"
            }
          else
            response.status = 200
          end

          if response.status == 200
            data[:domain_records][name] << rec.dup
            last = data[:domain_records][name].last
            last['name'] = %(#{last['name']}.#{name}.) unless last['name'].match(%r{\.$}) unless last['name'].eql?('@') #|| last['name'].eql?('*')
            last['id'] = Fog::Mock.random_numbers(8).to_i
            response.body = {
                "domain_record" => last
            }
          end

          response
        end
      end
    end
  end
end
