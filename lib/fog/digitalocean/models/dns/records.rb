# require 'fog/digitalocean/models/record'
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
          data = service.list_records(domain.name, filters)
          links = data.body['links']
          get_paged_links(links)
          keys = data.body["domain_records"]
          load(keys)
        end

        def all!(filters = {})
          list = all(filters)
          begin
            page = next_page(filters)
            list += page if page
          end while page
          list
        end

        # Returns record
        # @return [Fog::DNS::DigitalOceanV2::Records] Retrieves a list of records
        # @raise [Fog::DNS::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::DNS::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::DNS::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::DNS::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-key
        def get(id)
          resp = service.get_record(domain.name, id)
          key = resp.body['domain_record'] rescue nil
          if key
            new(key)
          else
            nil
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def create(attributes = {})
          object = super
          self.replace(self.all!)
          object
        end

        def delete(id)
          id = id.id if id.is_a?(Fog::Model)
          id = id.with_indifferent_access[:id] if id.is_a?(Hash)
          return false unless id
          response = service.delete_record(self.domain.name, id)
          if response.status == 204
            self.replace(self.select{ |dom| dom.id != id })
            true
          else
            false
          end
        rescue Fog::Errors::NotFound
          nil
        end

        def new(attributes = {})
          requires :domain
          super({ :domain => domain }.merge!(attributes))
        end

        def to_s
          @domain
        end
      end
    end
  end
end
