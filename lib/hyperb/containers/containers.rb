require 'hyperb/request'
require 'hyperb/containers/container'
require 'hyperb/utils'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # wrapper for containers api
  module Containers
    include Hyperb::Utils

    # list existing containers
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] raised when 5xx is returned from hyper.
    #
    # @return [Hyperb::Container] Array of Hyperb::Container.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [Boolean] :all show all containers, false by default
    # @option params [Boolean] :size show containers size
    # @option params [String] :limit show `limit` last created containers.
    # @option params [String] :since show only containers created since Id.
    # @option params [String] :before only containers created before Id.
    # TODO: @option params [Hash] :filters JSON encoded value of the filters.
    def containers(params = {})
      path = '/containers/json'
      query = {}
      query.merge!(params)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform)
      response.map { |container| Hyperb::Container.new(container) }
    end

    # stop the container id
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/stop.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when container can't be found.
    # @raise [Hyperb::Error::Conflict] raised when container is running and can't be removed.
    # @raise [Hyperb::Error::InternalServerError] raised when a 5xx is returned.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [Boolean] :t number of seconds to wait before killing the container.
    def stop_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/stop'
      query = {}
      query[:t] = params[:t] if params.key?(:t)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # remove the container id
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/delete.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when container can't be found.
    # @raise [Hyperb::Error::Conflict] raised when container is running and can't be removed.
    # @raise [Hyperb::Error::InternalServerError] raised when a 5xx is returned.
    #
    # @return [Hash] downcased symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [Boolean] :v remove volumes attached. default false
    # @option params [Boolean] :force force remove. default false
    def remove_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id]
      query = {}
      query[:v] = params[:v] if params.key?(:v)
      query[:force] = params[:force] if params.key?(:force)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'delete').perform)
      downcase_symbolize(response)
    end

    # create a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::Conflict] raised container with the same name is already created.
    # @raise [Hyperb::Error::InternalServerError] raised when a 5xx is returned
    #
    # @return [Hash] hash containing downcased symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [String] :name container name
    # @option params [String] :image image to be used
    # @option params [String] :hostname container hostname
    # @option params [String] :entrypoint container entrypoint
    # @option params [String] :cmd container command
    #
    # @option params [Hash] :labels hash containing key: value
    # @option params labels [String] :sh_hyper_instancetype container size: s1, s2, s3 ...
    def create_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'image')
      path = '/containers/create'
      query = {}

      # set a default size, otherwise container can't be started
      body = { labels: { sh_hyper_instancetype: 's1' } }
      query[:name] = params[:name] if params.key?(:name)
      params.delete(:name)
      body.merge!(params)

      response = JSON.parse(Hyperb::Request.new(self, path, query, 'post', body).perform)
      downcase_symbolize(response)
    end

    # inspect a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/inspect.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::InternalServerError] raised when 5xx is returned.
    #
    # @return [Hash] Array of downcased symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [String] :id container's name or id
    # @option params [String] :size include container's size on response
    def inspect_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/json'
      query = {}
      query[:size] = params[:size] if params.key?(:size)
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
    # @raise [Hyperb::Error::InternalServerError] raised when a 5xx is returned.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id container's name or id
    def start_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/start'
      Hyperb::Request.new(self, path, {}, 'post').perform
    end

    # container logs
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/logs.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::BadRequest] raised when request is invalid.
    # @raise [Hyperb::Error::InternalServerError] raised when a 5xx is returned.
    #
    # @return [HTTP::Response::Body] a streamable http response body object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id container's name or id
    # @option params [String] :follow stream output
    # @option params [String] :stderr stream stderr
    # @option params [String] :stdout stream stdout
    # @option params [String] :since stream outputs since id
    # @option params [String] :timestamps include timestamps on stdouts, default false
    # @option params [String] :tail tail number
    def container_logs(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/logs'
      query = {}
      params.delete(:id)
      query.merge!(params)
      Hyperb::Request.new(self, path, query, 'get').perform
    end

    # container stats
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/logs.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::BadRequest] raised when request is invalid.
    # @raise [Hyperb::Error::InternalServerError] raised when 5xx is returned.
    #
    # @return [HTTP::Response::Body] a streamable http response body object
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id container's name or id
    # @option params [String] :stream stream output
    def container_stats(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/stats'
      query = {}
      query[:stream] = params[:stream] if params.key?(:stream)
      Hyperb::Request.new(self, path, query, 'get').perform
    end

    # kill a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/kill.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::InternalServerError] raised when 5xx is returned.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id container's name or id
    # @option params [String] :signal stream output
    def kill_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/containers/' + params[:id] + '/kill'
      query = {}
      query[:signal] = params[:signal] if params.key?(:signal)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # rename a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Container/rename.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when the container can't be found.
    # @raise [Hyperb::Error::InternalServerError] raised when 5xx is returned.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id new name
    # @option params [String] :name new name
    def rename_container(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'name', 'id')
      path = '/containers/' + params[:id] + '/rename'
      query = {}
      query[:name] = params[:name] if params.key?(:name)
      Hyperb::Request.new(self, path, query, 'post').perform
    end
  end
end
