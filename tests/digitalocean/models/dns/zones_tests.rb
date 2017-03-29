Shindo.tests("Fog::DNS[:digitalocean] | domains", ['digitalocean', 'dns']) do
  params = {:name => generate_unique_domain }
  collection_tests(Fog::DNS[:digitalocean].domains, params)
end
