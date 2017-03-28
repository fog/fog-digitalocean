module Fog
  module DNS
    class DigitalOcean
      # noinspection RubyStringKeysInHashInspection
      class Real

        def create_domain(name, ip_address)
          create_options = {
            :name       => name,
            :ip_address => ip_address,
          }

          encoded_body = Fog::JSON.encode(create_options)

          request(
            :expects => [201],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => '/v2/domains',
            :body    => encoded_body,
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def create_domain(name, ip_address)
          response        = Excon::Response.new
          response.status = 200

          data[:domains] << {
              'name'      => name,
              'ttl'       => 1800,
              'zone_file' => "$ORIGIN #{name}.\n$TTL 1800\n#{name}. IN SOA ns1.digitalocean.com. hostmaster.#{name}. 1490145863 10800 3600 604800 1800\n#{name}. 1800 IN NS ns1.digitalocean.com.\n#{name}. 1800 IN NS ns2.digitalocean.com.\n#{name}. 1800 IN NS ns3.digitalocean.com.\n#{name}. 1800 IN A #{ip_address}\n"
          }

          response.body ={
            'domain' => data[:domains].last
          }

          response
        end
      end
    end
  end
end
