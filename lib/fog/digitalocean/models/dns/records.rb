require 'fog/digitalocean/models/paging_collection'

module Fog
  module DNS
    class DigitalOcean
      class Records < Fog::Compute::DigitalOcean::PagingCollection
        attribute :domain

        model Fog::DNS::DigitalOcean::Record

        # Returns list of records
        # @return [Fog::DNS::DigitalOceanV2::Records] Retrieves a list of domains.
        # @raise [Fog::DNS::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::DNS::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::DNS::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::DNS::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#list-all-keys
        def all(filters = {})
          data = service.list_domain_records(filters)
          links = data.body["links"]
          get_paged_links(links)
          keys = data.body["records"]
          load(keys)
        end

        # Returns record
        # @return [Fog::DNS::DigitalOceanV2::Records] Retrieves a list of records
        # @raise [Fog::DNS::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::DNS::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::DNS::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::DNS::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-key
        def get(id)
          key = service.get_domain(id).body['id']
          new(key) if key
        rescue Fog::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :domain
          super({ :zone => zone }.merge!(attributes))
        end
      end
    end
  end
end
