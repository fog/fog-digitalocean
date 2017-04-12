module Fog
  module DNS
    class DigitalOcean
      class Zone < Fog::DNS::DigitalOcean::Domain

        identity :name
        attribute :ttl
        attribute :zone_file
        attribute :ip_address
      end
    end
  end
end