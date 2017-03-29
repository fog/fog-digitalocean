module Fog
  module DNS
    class DigitalOcean
      class Domain < Fog::Model
        identity :name
        attribute :ttl
        attribute :zone_file
        attribute :ip_address

        def initialize(attributes={})
          attributes = attributes.with_indifferent_access
          attributes[:ip_address] ||= '127.0.0.1'
          super
        end

        def create
          requires :name, :ip_address
          resp = service.create_domain(name, ip_address)
          merge_attributes(resp.body['domain'])
          true
        end
        alias :save :create

        def delete
          requires :name
          service.delete_domain name
        end
        alias :destroy :delete

        def get
          requires :name
          service.get_domain name
        end

        def records
          @records ||= begin
            Fog::DNS::DigitalOcean::Records.new(
                :domain => self,
                :service => service
            )
          end
        end
      end
    end
  end
end