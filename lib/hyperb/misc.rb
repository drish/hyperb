require 'hyperb/request'
require 'json'

module Hyperb
  # simple wrapper for the version endpoint
  module Misc
    # returns current version of hyper.sh api
    def version
      JSON.parse(Hyperb::Request.new(self, '/version', {}, 'get').perform)
    end

    # returns system-wide information about user account
    def info
      JSON.parse(Hyperb::Request.new(self, '/info', {}, 'get').perform)
    end
  end
end
