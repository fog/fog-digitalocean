module Fog
  module DNS
    class DigitalOcean
      class Zones < Fog::DNS::DigitalOcean::Domains
        model Fog::DNS::DigitalOcean::Zone
      end
    end
  end
end
