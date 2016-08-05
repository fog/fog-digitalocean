module Fog
  module Compute
    class DigitalOcean
      class Volume < Fog::Model
        identity :id
        attribute :name
        attribute :region
        attribute :droplet_ids
        attribute :distribution
        attribute :size_gigabytes
        attribute :created_at
      end

      def transfer
        perform_action :transfer_image
      end

      def convert_to_snapshot
        perform_action :convert_image_to_snapshot
      end
    end
  end
end
