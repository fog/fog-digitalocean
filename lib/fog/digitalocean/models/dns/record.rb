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

        def create
          requires :name, :type, :data
          merge_attributes(service.create_domain_record(name, type, data).body['id'])
          true
        end

        def delete
          requires :id
          service.delete_domain_record name
        end

        def update
          requires :id, :name, :type, :data
          service.create_domain_record name, type, data
          service.delete_domain_record id
        end
      end
    end
  end
end