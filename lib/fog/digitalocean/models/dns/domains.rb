require 'fog/digitalocean/models/paging_collection'

module Fog
  module DNS
    class DigitalOcean
      class Domains < Fog::Compute::DigitalOcean::PagingCollection
        model Fog::DNS::DigitalOcean::Domain

        # Returns list of domains
        # @return [Fog::DNS::DigitalOceanV2::Domains] Retrieves a list of ssh keys.
        # @raise [Fog::DNS::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::DNS::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::DNS::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::DNS::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#list-all-keys
        def all(filters = {})
          data = service.list_domains(filters)
          links = data.body['meta']['links']
          get_paged_links(links)
          keys = data.body["domains"]
          load(keys)
        end

        # Returns domain
        # @return [Fog::DNS::DigitalOceanV2::Domains] Retrieves a list of ssh keys.
        # @raise [Fog::DNS::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::DNS::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::DNS::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::DNS::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-key
        def get(id)
          key = service.get_domain(id).body['domain']
          new(key) if key
        rescue Fog::Errors::NotFound
          nil
        end

        def delete(id)
          id = id.name if id.is_a?(Fog::Model)
          id = id.with_indifferent_access[:name] if id.is_a?(Hash)
          return false unless id
          response = service.delete_domain(id)
          if response.status == 204
            self.replace(self.select{ |dom| !dom.name.eql?(id)})
            true
          else
            false
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def create(attributes = {})
          object = super
          self << object
          object
        end
      end
    end
  end
end
