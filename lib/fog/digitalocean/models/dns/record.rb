require 'active_support/core_ext/hash/indifferent_access'

module Fog
  module DNS
    class DigitalOcean
      class Record < Fog::Model

        # provider_class :Record
        # collection_name :records

        identity :id, type: 'Integer'         # number	A unique identifier for each domain record.
        attribute :type                       # string	The type of the DNS record (ex: A, CNAME, TXT, ...).
        attribute :name	                      # string	The name to use for the DNS record.
        attribute :data                 	    # string	The value to use for the DNS record.
        attribute :priority, type: 'Integer'  # nullable number	The priority for SRV and MX records.
        attribute :port	   , type: 'Integer'  # nullable number	The port for SRV records.
        attribute :weight	 , type: 'Integer'  # nullable number	The weight for SRV records.

        def initialize(new_attrs={})
          new_attrs = new_attrs.with_indifferent_access
          new_attrs[:data] ||= new_attrs[:value]
          new_attrs[:data] ||= new_attrs[:host]
          new_attrs[:priority] ||= new_attrs[:pri]
          super
          @attributes = @attributes.with_indifferent_access
          self
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
          data = (self.id ? service.update_record(domain.name, options) : service.create_record(domain.name, options)).body['domain_record']
          merge_attributes(data)
          true
        end

        def to_h
          self.attributes
        end

        def value
          @attributes[:data]
        end

        def value=(val)
          @attributes[:data] = val
        end

        def host
          @attributes[:data]
        end

        def host=(val)
          @attributes[:data] = val
        end

        def [](key)
          @attributes[key]
        end

        def []=(key, val)
          @attributes[key] = val
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