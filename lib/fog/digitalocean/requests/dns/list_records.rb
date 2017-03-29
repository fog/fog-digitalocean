module Fog
  module DNS
    class DigitalOcean

      class Real
        def list_records(name, filters = {})
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "v2/domains/#{name}/records",
            :query   => filters
          )
        end
      end

      # noinspection RubyStringKeysInHashInspection
      class Mock
        def list_records(name, filters = {})

          filters = filters.with_indifferent_access
          filters[:per_page] ||= 25
          filters[:page] ||= 1
          raise Fog::Errors::Error.new("Invalid page size") if filters[:per_page] > 200

          response        = Excon::Response.new
          if data[:domain_records][name]
            response.status = 200
            records = data[:domain_records][name]
            links = {}
            if records.count > filters[:per_page]
              per_page = filters[:per_page] != 25 ? "&per_page=#{filters[:per_page]}" : ''
              pages = {}

              pages['first'] = "?page=1#{per_page}" unless filters[:page] == 1
              pages['prev'] = "?page=(filters[:page]-1).to_s#{per_page}" unless filters[:page] == 1
              pages['next'] = "?page=#{(filters[:page]+1).to_s}#{per_page}" if (records.size - filters[:page] * filters[:per_page]) > 0
              pages['last'] = "?page=#{(records.size / filters[:per_page] + 1).to_i}#{per_page}" if (records.size - filters[:page] * filters[:per_page]) > 0
              links = {
                'links' => {
                  'pages' => pages
                }
              }
            end
            response.body = {
                "domain_records" => records[(filters[:page]-1) * filters[:per_page]..filters[:page] * filters[:per_page] - 1],
                "meta" => {
                    "total" => data[:domain_records][name].count
                }.merge(links)
            }
          else
            response.status = 404
            response.body = {
                'id'      => 'not_found',
                'message' => 'The resource you were accessing could not be found.'
            }
            raise Fog::Errors::NotFound response.body['message']
          end
          response
        end
      end
    end
  end
end
