Shindo.tests("Fog::DNS[:digitalocean] | domain", ['digitalocean', 'dns']) do
  tests("domains.cleanup").succeeds do
    tests = Fog::DNS[:digitalocean].domains.all.select { |domain|
      domain.name =~ /^test-[0-9]{12}\.com/
    }
    tests.each do |domain|
      domain.delete
    end
    true
  end

  params = {:name => generate_unique_domain }
  model_tests(Fog::DNS[:digitalocean].domains, params)
end
