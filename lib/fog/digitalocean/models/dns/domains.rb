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
          links = data.body["links"]
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
          key = service.get_domain(id).body['name']
          new(key) if key
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
