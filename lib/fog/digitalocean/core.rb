require 'fog/core'
require 'fog/json'

module Fog
  module DigitalOcean
    extend Fog::Provider
    service(:compute, 'Compute')
    service(:dns, 'DNS')
  end
end
