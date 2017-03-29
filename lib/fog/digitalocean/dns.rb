require 'fog/digitalocean/core'
require 'active_support/core_ext/hash/indifferent_access'

module Fog
  module DNS
    class DigitalOcean < Fog::Service
      requires :digitalocean_token

      model_path 'fog/digitalocean/models/dns'
      model       :domain
      collection  :domains
      model       :record
      collection  :records

      request_path 'fog/digitalocean/requests/dns'
      request :list_domains
      request :create_domain
      request :get_domain
      request :delete_domain

      request :list_records
      request :create_record
      request :get_record
      request :update_record
      request :delete_record

      class Mock
        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :domains  => [
                  {
                      "name" => "domain.com",
                      "ttl" => 1800,
                      "zone_file" => "$ORIGIN domain.com.\n$TTL 1800\ndomain.com. IN SOA ns1.digitalocean.com. hostmaster.domain.com. 1490145863 10800 3600 604800 1800\ndomain.com. 1800 IN NS ns1.digitalocean.com.\ndomain.com. 1800 IN NS ns2.digitalocean.com.\ndomain.com. 1800 IN NS ns3.digitalocean.com.\ndomain.com. 1800 IN A 127.0.0.3\n"
                  },
                  {
                      "name" => "domain.net",
                      "ttl" => 1800,
                      "zone_file" => "$ORIGIN domain.net.\n$TTL 1800\ndomain.net. IN SOA ns1.digitalocean.com. hostmaster.domain.net. 1488909707 10800 3600 604800 1800\ndomain.net. 1800 IN NS ns1.digitalocean.com.\ndomain.net. 1800 IN NS ns2.digitalocean.com.\ndomain.net. 1800 IN NS ns3.digitalocean.com.\ndomain.net. 1800 IN A 64.99.64.37\n"
                  },
                  {
                      "name" => "domain.org",
                      "ttl" => 1800,
                      "zone_file" => "$ORIGIN domain.org.\n$TTL 1800\ndomain.org. IN SOA ns1.digitalocean.com. hostmaster.domain.org. 1488395060 10800 3600 604800 1800\ndomain.org. 1800 IN NS ns1.digitalocean.com.\ndomain.org. 1800 IN NS ns2.digitalocean.com.\ndomain.org. 1800 IN NS ns3.digitalocean.com.\ndomain.org. 3600 IN A 208.38.128.210\ndomain.org. 1800 IN MX 1 aspmx.l.google.com.\ndomain.org. 1800 IN MX 5 alt1.aspmx.l.google.com.\ndomain.org. 1800 IN MX 5 alt2.aspmx.l.google.com.\ndomain.org. 1800 IN MX 10 alt3.aspmx.l.google.com.\ndomain.org. 1800 IN MX 10 alt4.aspmx.l.google.com.\n"
                  }
              ],
              :domain_records => {
                'domain.com' =>
                  [
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns1.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns2.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns3.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "A",
                      "name" => "@",
                      "data" => "127.0.0.1",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    }
                  ],
                'domain.net' =>
                  [
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns1.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns2.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns3.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "A",
                      "name" => "@",
                      "data" => "127.0.0.1",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    }
                  ],
                'domain.org' =>
                  [
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns1.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns2.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "NS",
                      "name" => "@",
                      "data" => "ns3.digitalocean.com",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    },
                    { "id" => Fog::Mock.random_numbers(8).to_i,
                      "type" => "A",
                      "name" => "@",
                      "data" => "127.0.0.1",
                      "priority" => nil,
                      "port" => nil,
                      "weight" => nil
                    }
                  ],
              }
            }
          end
        end

        def initialize(options={})
          @digitalocean_token = options[:digitalocean_token]
        end

        def data
          self.class.data[@digitalocean_token]
        end

        def reset_data
          self.class.data.delete(@digitalocean_token)
        end
      end

      class Real
        def initialize(options={})
          digitalocean_token = options[:digitalocean_token]
          persistent         = false
          options            = {
            headers: {
              'Authorization' => "Bearer #{digitalocean_token}",
            }
          }
          @connection        = Fog::Core::Connection.new 'https://api.digitalocean.com', persistent, options
        end

        def request(params)
          params[:headers] ||= {}
          begin
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
                    when Excon::Errors::NotFound
                      NotFound.slurp(error)
                    else
                      error
                  end
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
