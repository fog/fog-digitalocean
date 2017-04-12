module Fog
  module DNS
    class DigitalOcean
      class Domain < Fog::Model

        # has_many :records, :records

        identity :name
        attribute :ttl
        attribute :zone_file
        attribute :ip_address

        def initialize(attributes={})
          attributes = attributes.with_indifferent_access
          attributes[:ip_address] ||= '127.0.0.1'
          super
          @attributes = @attributes.with_indifferent_access
          self
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

        def domain
          requires :name
          self.name
        end
        alias :zone :domain

        def records
          @records ||= begin
            Fog::DNS::DigitalOcean::Records.new(
                :domain => self,
                :service => service
            )
          end
        end

        def zonefile
          @zonefile ||= begin
            reload unless  zone_file
            require 'zonefile'

            ::Zonefile.new(zone_file)
          end
        end

        def nameservers
          @nameservers ||= begin
            zonefile.records.with_indifferent_access['ns'].map { |rec| rec[:host] }
            # else
            #   self.records.all!.select { |rec| rec.type.eql?('NS') }.map { |rec| rec.data }
            # end
          end
        end

        def soa
          @soa ||= begin
            zonefile.soa.with_indifferent_access
          end
        end

        def ttl
          @ttl ||= begin
            zonefile.ttl.to_i
          end
        end

        def to_h
          self.attributes
        end
      end
    end
  end
end