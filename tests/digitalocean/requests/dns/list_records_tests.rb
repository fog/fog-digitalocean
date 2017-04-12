Shindo.tests('Fog::DNS::DigitalOcean | list_records("domain.net") request', ['digitalocean', 'dns']) do
  service = Fog::DNS.new(:provider => 'DigitalOcean')

  record_format = {
    'id' => Integer,
    'type' => String,
    'name' => String,
    'data' => String,
    # 'priority' => Integer,
    # 'port' => Integer,
    # 'weight' => Integer,
  }

  tests('success') do
    tests('#list_records') do
      body = service.list_domains.body
      domain = body['domains'].last.with_indifferent_access
      if domain
        response = service.list_records(domain[:name])
        if response.status == 200
          domain_records = response.body['domain_records']

          test('record count') do
            domain_records.size >= 4
          end

          domain_records.each do |record|
            tests('format').data_matches_schema(record_format) do
              record
            end
          end
        end

        response.status == 200
      else
        false
      end
    end
  end
end