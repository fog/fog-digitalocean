module Fog
  module DNS
    class DigitalOcean
      class Domain < Fog::Model
        identity :name
        attribute :ttl
        attribute :zone_file
        # attribute :ip_address

        def create
          requires :name, :ip_address
          merge_attributes(service.create_domain(name, ip_address).body['name'])
          true
        end

        def delete
          requires :name
          service.delete_domain name
        end

        def get
          requires :name
          service.get_domain name
        end
      end
    end
  end
end