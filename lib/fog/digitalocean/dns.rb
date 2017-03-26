require 'fog/digitalocean/core'

module Fog
  module DNS
    class DigitalOcean < Fog::Service
      requires :digitalocean_token

      model_path 'fog/digitalocean/models/dns'
      model       :record
      collection  :records
      model       :zone
      collection  :zones

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
              :servers  => [],
              :ssh_keys => []
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
