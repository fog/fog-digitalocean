Shindo.tests("Fog::DNS[:digitalocean] | records", ['digitalocean', 'dns']) do

  tests("domains.cleanup").succeeds do
    tests = Fog::DNS[:digitalocean].domains.all.select { |domain|
      domain.name =~ /^test-[0-9]{12}\.com/
    }
    tests.each do |domain|
      domain.delete
    end
    true
  end

  @domain = nil
  tests("domains.create").succeeds do
    @domain = Fog::DNS[:digitalocean].domains.create(name: generate_unique_domain)
  end

  param_groups = [
    # A record
    { :name => "#{@domain.name}.", :type => 'A', :ttl => 3600, :data => '1.2.3.4' },
    { :name => '@', :type => 'A', :ttl => 3600, :data => '5.6.7.8' },
    # CNAME record
    { :name => "www", :type => "CNAME", :ttl => 300, :data => "#{@domain.name}." }
  ]

  param_groups.each do |params|
    collection_tests(@domain.records, params)
  end

  records = []

  100.times do |i|
    records << @domain.records.create(:name => "#{i}", :type => "A", :ttl => 3600, :data => '1.2.3.4')
  end

  records << @domain.records.create(:name => "*", :type => "A", :ttl => 3600, :data => '1.2.3.4')

  tests("#all!").returns(105) do # We get an A record and 3 NS records "for free" ;)
    @domain.records.all!.size
  end

  tests("#all wildcard parsing").returns(true) do
    set = @domain.records.all!.map(&:name)
    set.include?('*') || set.include?("*.#{@domain.name}.")
  end

  records.each do |record|
    record.destroy
  end

  tests("zones#destroy").succeeds do
    @domain.destroy
  end
end
