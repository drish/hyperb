require 'hyperb/request'
require 'json'

module Hyperb
  # simple wrapper for the version endpoint
  module HyperVersion
    # returns current version of hyper.sh api
    def version
      JSON.parse(Hyperb::Request.new(self, '/version', {}, 'get').perform)
    end
  end
end
