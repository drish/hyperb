require 'hyperb/images/images'
require 'hyperb/hyper_version'

# wrapper for modules
module Hyperb

  module API
    include Hyperb::Images
    include Hyperb::HyperVersion
    # include Hyperb::Containers
    # include Hyperb::Fips
  end
end