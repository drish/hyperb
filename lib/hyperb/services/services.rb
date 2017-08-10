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
    # @param params image [String] service name
    # @param params name [String] image name
    # @param params replicas [Fixnum] numer of replicas
    # @param params service_port [Fixnum] service port
    # @param params container_port [Fixnum] container port
    # @param params labels [Hash] hash containing labels
    # @param params entrypoint [String] entrypoint
    # @param params cmd [String] command
    # @param params env [Array] array of envs ["env=value", ["env2=value"]]
    # @param params algorithm [String] algorithm of the service, 'roundrobin', 'leastconn'
    # @param params protocol [String] prot
    # @param params workingdir [String] working directory
    def create_service(params = {})
      valid = check_arguments(params, 'name', 'image', 'replicas', 'service_port', 'labels')
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
    def remove_service(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'name')
      path = '/services/' + params[:name]
      query = {}
      query[:keep] = params[:keep] if params.key?(:keep)
      Hyperb::Request.new(self, path, query, 'delete').perform
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
