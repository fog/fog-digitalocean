require 'active_support/core_ext/hash/indifferent_access'

module Fog
  module DNS
    class DigitalOcean
      class Record < Fog::Model
        identity :id        # number	A unique identifier for each domain record.
        attribute :type     # string	The type of the DNS record (ex: A, CNAME, TXT, ...).
        attribute :name	    # string	The name to use for the DNS record.
        attribute :data	    # string	The value to use for the DNS record.
        attribute :priority	# nullable number	The priority for SRV and MX records.
        attribute :port	    # nullable number	The port for SRV records.
        attribute :weight	  # nullable number	The weight for SRV records.

        def initialize(attributes={})
          super
        end

        def domain
          @domain
        end

        def create
          requires :name, :type, :data
          merge_attributes(service.create_domain_record(name, type, data).body['id'])
          true
        end

        def delete
          requires :id
          service.delete_record(domain.name, id)
        end
        alias :destroy :delete

        def update(delta={})
          requires :id
          options = attributes_to_options('UPDATE')
          delta = options.merge(delta.with_indifferent_access)
          delta.delete('id')
          data = service.create_record(domain.name, delta).body['domain_record'].with_indifferent_access
          service.delete_record(domain.name, options)
          merge_attributes(data)
          true
        end
        alias :modify :update

        def save
          options = attributes_to_options('CREATE')
          data = service.create_record(domain.name, options).body['domain_record']
          merge_attributes(data)
          true
        end

        private

        def domain=(new_zone)
          @domain = new_zone
        end

        def attributes_to_options(action)
          requires :name, :type, :data
          # requires_one :value, :alias_target
          options = {
              id:        id,
              name:      name,
              type:      type,
              data:      data,
              priority:  priority,
              port:      port,
              weight:    weight,
          }
          options.with_indifferent_access
        end
      end
    end
  end
end