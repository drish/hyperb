require 'hyperb/images/images'
require 'hyperb/containers/containers'
require 'hyperb/snapshots/snapshots'
require 'hyperb/volumes/volumes'
require 'hyperb/network/fips'
require 'hyperb/compose/compose'
require 'hyperb/hyper_version'

module Hyperb
  # wrapper for apis
  module API
    include Hyperb::Images
    include Hyperb::Containers
    include Hyperb::Volumes
    include Hyperb::HyperVersion
    include Hyperb::Network
    include Hyperb::Snapshots
    include Hyperb::Compose
  end
end
