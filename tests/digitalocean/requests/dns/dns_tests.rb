require 'active_support/core_ext/hash/indifferent_access'

Shindo.tests('Fog::DNS[:digitalocean] | DNS requests', ['digitalocean', 'dns']) do

  @domain_count = 0
  @new_records  = []
  @domain_name  = generate_unique_domain
  # @domain       = Fog::DNS[:digitalocean].domains.create(:name => generate_unique_domain)

  @service = Fog::DNS[:digitalocean]

  tests('success') do

    test('get current zone count') do
      @domain_count= 0
      response     = @service.list_domains
      if response.status == 200
        @domains      = response.body['domains']
        @domain_count = @domains.count
      end

      response.status == 200
    end

    test('create simple zone') {
      result = false

      response = @service.create_domain(@domain_name, '1.2.3.4')
      if response.status == 200

        domain     = response.body['domain']
        name       = domain['name']
        ttl        = domain['ttl']
        zone_file  = domain['zone_file']

        if name and ttl and zone_file

          require 'zonefile'

          zf = ::Zonefile.new(zone_file)

          @zone_id = name
          @origin = zf.soa.with_indifferent_access[:origin]
          ns_srv_count = zf.records.with_indifferent_access[:ns].size

          if (@zone_id.length < @origin.length) and (ns_srv_count > 0) and (ttl.to_i == zf.ttl.to_i)
            result = true
          end
        end
      end

      result
    }

    test("get info on hosted zone #{@zone_id}") {
      result = false

      response = @service.get_domain(@zone_id)
      if response.status == 200
        domain     = response.body['domain']
        name       = domain['name']
        ttl        = domain['ttl']
        zone_file  = domain['zone_file']
        @zone_id = name

        if name and ttl and zone_file

          require 'zonefile'

          zf = ::Zonefile.new(zone_file)

          origin = zf.soa.with_indifferent_access[:origin]
          ns_srv_count = zf.records.with_indifferent_access[:ns].size

          if (name.length < origin.length) and (ns_srv_count > 0) and (ttl.to_i == zf.ttl.to_i)
            result = true
          end
        end
      end

      result
    }

    test('list zones') do
      result = false

      response = @service.list_domains
      if response.status == 200

        zones = response.body['domains']
        if (zones.count > 0)
          domain     = zones.last
          name       = domain['name']
          ttl        = domain['ttl']
          zone_file  = domain['zone_file']

          if name and ttl and zone_file

            require 'zonefile'

            zf = ::Zonefile.new(zone_file)

            origin = zf.soa.with_indifferent_access[:origin]
            ns_srv_count = zf.records.with_indifferent_access[:ns].size

            if (name.length < origin.length) and (ns_srv_count > 0) and (ttl.to_i == zf.ttl.to_i)
              result = true
            end
          end
        end
      end

      result
    end

    tests('add records') do
      require 'base64'
      # name: A, AAAA, CNAME, TXT, SRV, data: A, AAAA, CNAME, MX, TXT, SRV, NS
      [
        { name: 'www.' + @domain_name,  type: 'A',      ttl: 3600, data: '1.2.3.4' },
        { name: 'www.' + @domain_name,  type: 'AAAA',   ttl: 3600, data: '1.2.3.4' },
        { name: 'mail.' + @domain_name, type: 'CNAME',  ttl: 3600, data: 'www.' + @domain_name },
        { name: @domain_name,           type: 'MX',     ttl: 3600, data: 'mail.' + @domain_name, priority: 6 },
        { name: @domain_name,           type: 'TXT',    ttl: 3600, data: Base64.encode64('txt.' + @domain_name) },
        { name: @domain_name,           type: 'SRV',    ttl: 3600, data: 'srv.' + @domain_name, priority: 6, port: 666, weight: 6 },
      ].each do |resource_record|
        rr = resource_record.with_indifferent_access
        test("add a #{rr[:type]} resource record") {
          # create an resource record
          response = @service.create_record(@zone_id, rr)

          if response.status == 200
            dr = response.body['domain_record'].with_indifferent_access
            if dr['name'].eql?(rr['name'])
              @new_records << dr
              @service.get_record(@zone_id, dr["id"]).body['domain_record']["name"].eql?(rr[:name])
            else
              false
            end
          else
            false
          end
        }
      end

    tests('update NS records') do
      require 'base64'
      ns_records = @service.list_records(@zone_id).body['domain_records'].select { |rec| rec['type'].eql?('NS') }
      ns_records.each do |resource_record|
        rr = resource_record.with_indifferent_access
        test("update a #{rr[:type]} resource record") {
          # update an resource record
          rr[:data].gsub!(%r{^(ns[1-3]\.).*}, '\1'+@zone_id)
          response = @service.update_record(@zone_id, rr)

          if response.status == 200
            dr = response.body['domain_record'].with_indifferent_access
            @new_records << dr
            @service.get_record(@zone_id, dr["id"]).body['domain_record']["name"].eql?(rr[:name])
          else
            false
          end
        }
      end

    end

    tests("list resource records")  {
      # get resource records for zone
      records = @service.list_records(@zone_id).body['domain_records'].map { |rec| rec.with_indifferent_access }
      rec_ids = @new_records.map { |rec| rec[:id] }
      test('all records found') do
        records.select { |rec|
          rec_ids.include?(rec[:id])
        }.size == @new_records.size
      end
    }

    test("delete #{@new_records.count} resource records") {
      change_batch = @new_records.map { |record| { id: record[:id] }.with_indifferent_access }

      results = @new_records.map do |rec|
        response = @service.delete_record(@zone_id, rec)
        if response.status == 200
          true
        else
          false
        end
      end
      results.select { |res| res === false }.size == 0
    }

    tests("test remaining resource records")  {
      # get resource records for zone
      records = @service.list_records(@zone_id).body['domain_records'].map { |rec| rec.with_indifferent_access }
      # rec_ids = @new_records.map { |rec| rec[:id] }
      test('only remaining records found') do
        records.size == 1
      end
      test('delete only remaining record') do
        response = @service.delete_record(@zone_id, records.last)
        response.status == 200
      end
      # rec_ids = @new_records.map { |rec| rec[:id] }
      test('no records found') do
        @service.list_records(@zone_id).body['domain_records'].size == 0
      end
    }

    test("delete hosted zone #{@zone_id}") {
      @service.delete_domain(@zone_id).status == 200
    }

  end

    tests('failure') do
      tests('create hosted zone using invalid domain name').raises(Excon::Errors::BadRequest) do
        pending if Fog.mocking?
        @service.create_domain('invalid-domain')
      end

      tests('get hosted zone using invalid ID').raises(Excon::Errors::NotFound) do
        pending if Fog.mocking?
        zone_id = 'dummy-id'
        @service.get_domain(zone_id)
      end

    end

  end

end
