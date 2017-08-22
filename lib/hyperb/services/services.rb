require 'hyperb/request'
require 'hyperb/utils'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # services module
  module Services
    include Hyperb::Utils

    # create a service
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Service/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hash] Hash containing service information.
    #
    # @param params [Hash] A customizable set of params.
    # @param params [String] :image  service name
    # @param params [String] :name image name
    # @param params [Fixnum] :replicas numer of replicas
    # @param params [Fixnum] :serviceport service port
    # @param params [Fixnum] :containerport container port
    # @param params [Hash] :labels hash containing labels
    # @param params [String] :entrypoint entrypoint
    # @param params [String] :cmd command
    # @param params [Boolean] :stdin keep STDIN open even if not attached.
    # @param params [Array] :env array of envs ["env=value", ["env2=value"]]
    # @param params [String] :algorithm algorithm of the service, 'roundrobin', 'leastconn'
    # @param params [String] :protocol prot
    # @param params [String] :workingdir working directory
    # @param params [Boolean] :sessionaffinity whether the service uses sticky sessions.
    # @param params [String] :securitygroups security group for the container.
    def create_service(params = {})
      valid = check_arguments(params, 'name', 'image', 'replicas', 'serviceport', 'labels')
      raise ArgumentError, 'Invalid arguments.' unless valid
      path = '/services/create'
      body = {}
      body.merge!(params)
      downcase_symbolize(JSON.parse(Hyperb::Request.new(self, path, {}, 'post', body).perform))
    end

    # remove service
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Service/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised service is not found.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :keep if true, keep containers running while removing the service.
    # @option params [String] :name service name.
    def remove_service(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'name')
      path = '/services/' + params[:name]
      query = {}
      query[:keep] = params[:keep] if params.key?(:keep)
      Hyperb::Request.new(self, path, query, 'delete').perform
    end

    # inspect a service
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Service/inspect.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] raised hyper returns 5xx.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :name service name.
    def inspect_service(params = {})
      valid = check_arguments(params, 'name')
      raise ArgumentError, 'Invalid arguments.' unless valid
      path = '/services/' + params[:name]
      downcase_symbolize(JSON.parse(Hyperb::Request.new(self, path, {}, 'get').perform))
    end

    # list service
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Service/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] raised hyper returns 5xx.
    def services
      path = '/services'
      downcase_symbolize(JSON.parse(Hyperb::Request.new(self, path, {}, 'get').perform))
    end
  end
end
