Shindo.tests("Fog::DNS[:digitalocean] | zones", ['digitalocean', 'dns']) do
  tests("zones.cleanup").succeeds do
    tests = Fog::DNS[:digitalocean].zones.all.select { |domain|
      domain.name =~ /^test-[0-9]{12}\.com/
    }
    tests.each do |domain|
      domain.delete
    end
    true
  end

  params = {:name => generate_unique_domain }
  collection_tests(Fog::DNS[:digitalocean].zones, params)
end
