Shindo.tests('Fog::DNS::DigitalOcean | list_records("domain.net") request', ['digitalocean', 'dns']) do
  service = Fog::DNS.new(:provider => 'DigitalOcean')

  record_format = {
    'id' => Integer,
    'type' => String,
    'name' => String,
    'data' => String,
    'priority' => Integer,
    'port' => Integer,
    'weight' => Integer,
  }

  tests('success') do
    tests('#list_records') do
      service.list_records('domain.net').body['domain_records'].each do |record|
        tests('format').data_matches_schema(record_format) do
          record
        end
      end
    end
  end
end