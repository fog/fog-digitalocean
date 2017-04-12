Shindo.tests("Fog::Dns[:digitalocean] | record", ['digitalocean', 'dns']) do

  tests("domains.cleanup").succeeds do
    tests = Fog::DNS[:digitalocean].domains.all.select { |domain|
      domain.name =~ /^test-[0-9]{12}\.com/
    }
    tests.each do |domain|
      domain.delete
    end
    true
  end

  tests("domains#create").succeeds do
    @domain = Fog::DNS[:digitalocean].domains.create(name: generate_unique_domain, ip_address: '5.5.5.5')
  end

  [
      { :name => "#{@domain.name}.", :type => 'A', :data => '1.2.3.4' },
      { :name => '@', :type => 'A', :data => '1.2.3.4' },
  ].each do |params|
    model_tests(@domain.records, params) do |instance|

      # Newly created records should have a change id
      tests("#id") do
        returns(true) { instance.id != nil }
      end

      tests("#modify").succeeds do
        new_value = '5.5.5.5'
        returns(true) { instance.modify('data' => new_value) }
        returns(new_value) { instance.data }
      end

    end
  end

  tests("domain.destroy").succeeds do
    @domain.destroy
  end

end
