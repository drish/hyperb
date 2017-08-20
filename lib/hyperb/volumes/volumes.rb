require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/volumes/volume'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # volumes module
  module Volumes
    include Hyperb::Utils

    # create volume
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] raised hyper server returns 5xx.
    #
    # @return [Hash] downcased symbolized volume information.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :name volume's name
    # @option params [Fixnum] :size volume size unit of GB, from 10-1000 (1TB).
    # @option params [String] :snapshot snapshotId
    def create_volume(params = {})
      path = '/volumes/create'
      body = {}
      body[:driver] = 'hyper'
      body[:name] = params[:name] if params.key?(:name)

      # setup driver opts
      body[:driveropts] = {}
      body[:driveropts][:snapshot] = params[:snapshot]
      body[:driveropts][:size] = params[:size].to_s

      response = JSON.parse(Hyperb::Request.new(self, path, {}, 'post', body).perform)
      downcase_symbolize(response)
    end

    # list volumes
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hyperb::Volume] Array of Hyperb::Volume.
    #
    # @param params [Hash] A customizable set of params.
    # TODO: @option params [String] :filters JSON encoded value of the filters
    # TODO: @option params filters [Boolean] :dangling
    def volumes(params = {})
      path = '/volumes'
      query = {}
      query[:filters] = params[:filters] if params.key?(:filters)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform)

      # hyper response atm comes inside a Volumes: [], unlike the images API
      # which is returned in a []
      response['Volumes'].map { |vol| Hyperb::Volume.new(vol) }
    end

    # remove volume
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id volume id or name
    # @option params [String] :all default is true
    # @option params [String] :filter only return image with the specified name
    def remove_volume(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/volumes/' + params[:id]
      Hyperb::Request.new(self, path, {}, 'delete').perform
    end

    # inspect a volume
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/inspect.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hash] of downcase symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id volume id or name
    def inspect_volume(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/volumes/' + params[:id]
      downcase_symbolize(JSON.parse(Hyperb::Request.new(self, path, {}, 'get').perform))
    end
  end
end
