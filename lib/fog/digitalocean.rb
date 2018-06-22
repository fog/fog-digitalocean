require 'fog/core'
require 'fog/json'

module Fog
  module Compute
    autoload :DigitalOcean, File.expand_path('../compute/digitalocean', __FILE__)
  end

  module DigitalOcean
    autoload :Service, File.expand_path('../digitalocean/service')

    extend Fog::Provider
    service(:compute, 'Compute')
  end
end
