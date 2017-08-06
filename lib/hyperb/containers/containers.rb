require 'hyperb/request'
require 'hyperb/containers/container'
require 'hyperb/utils'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  module Containers

    include Hyperb::Utils

    # list existing containers
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [Hyperb::Container] Array of Hyperb::Container.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [Boolean] :all show all containers. Only running containers are shown by default, false by default
    # @option params [Boolean] :size show containers size
    # @option params [String] :limit show `limit` last created containers, include non-running ones.
    # @option params [String] :since show only containers created since Id, include non-running ones.
    # @option params [String] :before show only containers created before Id, include non-running ones.
    # TODO: @option params [Hash] :filters a JSON encoded value of the filters to process on the images list.
    def containers(params = {})
      path = '/containers/json'
      query = {}
      query[:all] = params[:all] if params.has_key?(:all)
      query[:size] = params[:size] if params.has_key?(:size)
      query[:limit] = params[:limit] if params.has_key?(:limit)
      query[:before] = params[:before] if params.has_key?(:before)
      query[:since] = params[:since] if params.has_key?(:since)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform)
      response.map { |container| Hyperb::Container.new(container) }
    end

    # remove the container id
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/delete.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when container can't be found.
    # @raise [Hyperb::Error::Conflict] raised when container is running and can't be removed.
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [Hyperb::Container] Array of Hyperb::Container.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [Boolean] :v remove volumes attached. default false
    # @option params [Boolean] :force force remove. default false
    def remove_container(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'id')
      path = '/containers/' + params[:id]
      query = {}
      query[:v] = params[:v] if params.has_key?(:v)
      query[:force] = params[:force] if params.has_key?(:force)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'delete').perform)
      downcase_symbolize(response)
    end

    # create a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::Conflict] raised container with the same name is already created.
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [Hash] Array of downcased symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [String] :name container name
    # @option params [String] :image image to be used
    # @option params [String] :hostname container hostname
    # @option params [String] :entrypoint container entrypoint
    # @option params [String] :cmd container command

    # @option params [Hash] :labels hash containing key: value
    # @option params labels [String] :sh_hyper_instancetype container size: s1, s2, s3 . . .
    def create_container(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'image')
      path = '/containers/create'
      query, body = {}, {}
      body[:labels] = {}
      query[:name] = params[:name] if params.has_key?(:name)
      body[:image] = params[:image] if params.has_key?(:image)
      body[:hostname] = params[:hostname] if params.has_key?(:hostname)
      body[:entrypoint] = params[:entrypoint] if params.has_key?(:entrypoint)
      body[:cmd] = params[:cmd] if params.has_key?(:cmd)

      # set a default size, otherwise container can't be started
      if params.has_key?(:labels)
        body[:labels] = params[:labels]
        body[:labels][:sh_hyper_instancetype] = 's1' if !body[:labels].has_key?(:sh_hyper_instancetype)
      else
        body[:labels][:sh_hyper_instancetype] = 's1'
      end

      response = JSON.parse(Hyperb::Request.new(self, path, query, 'post', body).perform)
      downcase_symbolize(response)
    end

    # inspect a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/inspect.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [Hash] Array of downcased symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [String] :id container's name or id
    # @option params [String] :size include container's size on response
    def inspect_container(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/json'
      query = {}
      query[:size] = params[:size] if params.has_key?(:size)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform)
      downcase_symbolize(response)
    end

    # start a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/start.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::BadRequest] raised when request is invalid.
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [String]
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id container's name or id
    def start_container(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/start'
      Hyperb::Request.new(self, path, {}, 'post').perform
      ""
    end

    # container logs
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/logs.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::BadRequest] raised when request is invalid.
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [HTTP::Response::Body] a streamable http response body object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id container's name or id
    def container_logs(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/logs'
      query = {}
      query[:follow] = params[:follow] if params.has_key?(:follow)
      query[:stderr] = params[:stderr] if params.has_key?(:stderr)
      query[:stdout] = params[:stdout] if params.has_key?(:stdout)
      query[:since] = params[:since] if params.has_key?(:since)
      query[:timestamps] = params[:timestamps] if params.has_key?(:timestamps)
      query[:tail] = params[:tail] if params.has_key?(:tail)
      Hyperb::Request.new(self, path, query, 'get').perform
    end
  end

end