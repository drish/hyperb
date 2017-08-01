require 'hyperb/request'
require 'json'

module Hyperb

	module HyperVersion

    # returns current version of hyper.sh api
    def version
      JSON.parse(Hyperb::Request.new(self, '/version', 'get').perform)
    end
  end
end