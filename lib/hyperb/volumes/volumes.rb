require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/auth_object'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # volumes module
  module Volumes
    include Hyperb::Utils

    # remove volume
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :all default is true
    # @option params [String] :filter only return image with the specified name
    def remove_volume(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/volumes/' + params[:id]
      Hyperb::Request.new(self, path, {}, 'delete').perform
    end
  end
end
