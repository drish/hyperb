require 'hyperb/images/images'
require 'hyperb/containers/containers'
require 'hyperb/snapshots/snapshots'
require 'hyperb/services/services'
require 'hyperb/volumes/volumes'
require 'hyperb/network/fips'
require 'hyperb/compose/compose'
require 'hyperb/misc'
require 'hyperb/funcs/funcs'

module Hyperb
  # wrapper for apis
  module API
    include Hyperb::Images
    include Hyperb::Containers
    include Hyperb::Volumes
    include Hyperb::Misc
    include Hyperb::Network
    include Hyperb::Snapshots
    include Hyperb::Services
    include Hyperb::Compose
    include Hyperb::Funcs
  end
end
