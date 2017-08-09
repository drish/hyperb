require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/auth_object'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # compose api wrapper
  module Compose
    include Hyperb::Utils

    # stop and remove a compose project
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Compose/compose_down.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised ips are not found.
    #
    # @returns [HTTP::Response::Body] a streamable response object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :project project name
    # @option params [Boolean] :rmorphans rm containers for services not defined in the compose file
    # @option params [String] :rmi remove images, all/local
    # @option params [Boolean] :vol remove data volumes
    def compose_down(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'project')
      path = '/compose/down'
      query = {}
      query[:project] = params[:project] if params.key?(:project)
      query[:vol] = params[:vol] if params.key?(:vol)
      query[:rmi] = params[:rmi] if params.key?(:rmi)
      query[:rmorphans] = params[:rmorphans] if params.key?(:rmorphans)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # remove a compose project
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Compose/compose_rm.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised ips are not found.
    #
    # @returns [HTTP::Response::Body] a streamable response object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :project project name
    # @option params [String] :rmvol project name
    def compose_rm(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'project')
      path = '/compose/rm'
      query = {}
      query[:project] = params[:project] if params.key?(:project)
      query[:rmvol] = params[:rmvol] if params.key?(:rmvol)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # create and run a compose project
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Compose/compose_up.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised ips are not found.
    #
    # @returns [HTTP::Response::Body] a streamable response object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :project project name
    # @option params [Hash] :serviceconfigs a hash representing a docker compose file services block
    # @option params [Hash] :networkconfigs
    # @option params [Hash] :volumeconfigs
    def compose_up(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'project')
      path = '/compose/up'
      query = {}
      body = {}
      query[:project] = params[:project] if params.key?(:project)

      body[:serviceconfigs] = { 'M': {} } # inherited from libcompose

      params[:networkconfigs] if params.key?(:networkconfigs)
      body[:serviceconfigs][:M] = params[:serviceconfigs] if params.key?(:serviceconfigs)
      body[:volumeconfigs] = params[:volumeconfigs] if params.key?(:volumeconfigs)
      Hyperb::Request.new(self, path, query, 'post', body).perform
    end

    # create a compose project
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Compose/compose_create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised ips are not found.
    #
    # @returns [HTTP::Response::Body] a streamable response object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :project project name
    # @option params [Hash] :serviceconfigs a hash representing a docker compose file services block
    # @option params [Hash] :networkconfigs
    # @option params [Hash] :volumeconfigs
    def compose_create(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'project')
      path = '/compose/create'
      query = {}
      body = {}
      query[:project] = params[:project] if params.key?(:project)

      body[:serviceconfigs] = { 'M': {} } # inherited from libcompose

      body[:networkconfigs] = params[:networkconfigs] if params.key?(:networkconfigs)
      body[:serviceconfigs][:M] = params[:serviceconfigs] if params.key?(:serviceconfigs)
      body[:volumeconfigs] = params[:volumeconfigs] if params.key?(:volumeconfigs)
      Hyperb::Request.new(self, path, query, 'post', body).perform
    end
  end
end
