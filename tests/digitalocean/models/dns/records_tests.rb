Shindo.tests("Fog::DNS[:digitalocean] | records", ['digitalocean', 'dns']) do

  @domain = nil
  tests("zones#create").succeeds do
    @domain = Fog::DNS[:digitalocean].domains.create(name: generate_unique_domain)
  end

  param_groups = [
    # A record
    { :name => @domain.name, :type => 'A', :ttl => 3600, :data => '1.2.3.4' },
    # CNAME record
    { :name => "www.#{@domain.name}", :type => "CNAME", :ttl => 300, :data => @domain.name}
  ]

  param_groups.each do |params|
    collection_tests(@domain.records, params)
  end

  records = []

  100.times do |i|
    records << @domain.records.create(:name => "#{i}.#{@domain.name}", :type => "A", :ttl => 3600, :data => '1.2.3.4')
  end

  records << @domain.records.create(:name => "*.#{@domain.name}", :type => "A", :ttl => 3600, :data => '1.2.3.4')

  tests("#all!").returns(105) do # We get an A record and 3 NS records "for free" ;)
    @domain.records.all!.size
  end

  tests("#all wildcard parsing").returns(true) do
    @domain.records.map(&:name).include?("*.#{@domain.name}")
  end

  records.each do |record|
    record.destroy
  end

  tests("zones#destroy").succeeds do
    @domain.destroy
  end
end
