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
    # @raise [Hyperb::Error::InternalServerError] raised when a internal server error is returned from hyper.
    #
    # @return [Hash] Array of downcased symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @option params [String] :name container name
    # @option params [String] :image image to be used
    def create_container(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'image')
      path = '/containers/create'
      query, body = {}, {}
      query[:name] = params[:name] if params.has_key?(:name)
      body[:image] = params[:image] if params.has_key?(:image)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'post', body).perform)
      downcase_symbolize(response)
    end

  end
end