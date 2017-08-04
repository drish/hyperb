require 'hyperb/images/images'
require 'hyperb/containers/containers'
require 'hyperb/hyper_version'

# wrapper for modules
module Hyperb

  module API
    include Hyperb::Images
    include Hyperb::Containers
    include Hyperb::HyperVersion
    # include Hyperb::Fips
  end
end