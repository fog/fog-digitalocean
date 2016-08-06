module Fog
  module Compute
    class DigitalOcean
      class Real
        def attach_volume(volume_id, droplet_id, region)
          body = { :type => 'attach', droplet_id: droplet_id, region: region}

          encoded_body = Fog::JSON.encode(body)

          request(
            :expects => [201],
            :headers => {
              'Content-Type' => "application/json; charset=UTF-8",
            },
            :method  => 'POST',
            :path    => "v2/images/#{volume_id}/actions",
            :body    => encoded_body,
          )
        end
      end

      class Mock
        def attach_volume(volume_id, droplet_id, region)
          response         = Excon::Response.new
          response.status  = 201
          response.body    = {
            'action' => {
              'id' => 46592838,
              'status' => 'completed',
              'type' => 'convert_to_snapshot',
              'started_at' => '2015-03-24T19:02:47Z',
              'completed_at' => '2015-03-24T19:02:47Z',
              'resource_id' => 11060029,
              'resource_type' => 'image',
              'region' => null,
              'region_slug' => null
            }
          }
          response
        end
      end
    end
  end
end
