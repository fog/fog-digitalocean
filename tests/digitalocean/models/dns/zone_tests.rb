Shindo.tests("Fog::DNS[:digitalocean] | zone", ['digitalocean', 'dns']) do
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
  model_tests(Fog::DNS[:digitalocean].zones, params)
end
