Shindo.tests('Fog::DNS::DigitalOcean | list_zones request', ['digitalocean', 'dns']) do
  service = Fog::DNS.new(:provider => 'DigitalOcean')

  domain_format = {
      'name' => String,
      'ttl' => Integer,
      'zone_file' => String,
  }

  tests('success') do
    tests('#list_zones') do
      service.list_zones.body['domains'].each do |domain|
        tests('format').data_matches_schema(domain_format) do
          domain
        end
      end
    end
  end
end