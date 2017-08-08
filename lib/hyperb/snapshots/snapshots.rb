require 'hyperb/snapshots/snapshot'
require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/auth_object'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # snapshots api wrapper
  module Snapshots
    include Hyperb::Utils

    # create a snapshot
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Snapshot/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] server error on hyper side.
    # @raise [Hyperb::Error::NotFound] raised when volume is not found.
    # @raise [ArgumentError] when required arguments are not provided.
    #
    # @return [Hash] symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [String] :volume volume id
    # @option params [String] :name snapshot's name
    def create_snapshot(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'name', 'volume')
      path = '/snapshots/create'
      query = {}
      query[:name] = params[:name] if params.key?(:name)
      query[:volume] = params[:volume] if params.key?(:volume)
      res = JSON.parse(Hyperb::Request.new(self, path, query, 'post').perform)
      downcase_symbolize(res)
    end
  end
end
