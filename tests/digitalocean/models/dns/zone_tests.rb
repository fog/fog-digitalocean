Shindo.tests("Fog::DNS[:digitalocean] | domain", ['digitalocean', 'dns']) do
  params = {:name => generate_unique_domain }
  model_tests(Fog::DNS[:digitalocean].domains, params)
end
