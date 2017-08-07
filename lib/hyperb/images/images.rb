require 'hyperb/images/image'
require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/auth_object'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # images api wrapper
  module Images
    include Hyperb::Utils
    # list images
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hyperb::Image] Array of Images.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :all default is true
    # @option params [String] :filter only return image with the specified name
    def images(params = {})
      path = '/images/json'
      query = {}
      query[:all] = params[:all] || true
      query[:filter] = params[:filter] if params.key?(:filter)
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform)
      response.map { |image| Hyperb::Image.new(image) }
    end

    # create (pull) an image
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] server error on hyper side.
    # @raise [ArgumentError] when required arguments are not provided.
    #
    # @return [HTTP::Response::Body] a streamable response object.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @required @option params [String] :from_image image name to be pulled
    # @option params [String] :tag image tag name
    #
    # @option params [Hash] :x-registry-auth object containing either login information, or a token
    # @option params x-registry-auth [String] :username
    # @option params x-registry-auth [String] :email
    # @option params x-registry-auth [String] :password
    #
    # TODO: @option params [Boolean] :stdout print stream to stdout
    def create_image(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'from_image')
      path = '/images/create'
      query = { fromImage: params[:from_image] }
      query[:tag] = params[:tag] if params.key?(:tag)
      additional_headers = {}
      if params.key?(:x_registry_auth)
        auth = params[:x_registry_auth]
        additional_headers[:x_registry_auth] = Hyperb::AuthObject.new(auth).encode
      end
      res = Hyperb::Request.new(self, path, query, 'post', '', additional_headers).perform
      res
    end

    # remove an image
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when tag is not found.
    # @raise [Hyperb::Error::Conflict] raised when the image will only be removed with force.
    # @raise [Hyperb::Error::InternalServerError] server error.
    #
    # @return [Array] array of downcase symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :name image name to be removed
    # @option params [Boolean] :force force image to be removed
    def remove_image(params = {})
      path = '/images/' + params[:name]
      query = {}
      query[:force] = true if params.key?(:force)
      res = JSON.parse(Hyperb::Request.new(self, path, query, 'delete').perform)
      downcase_symbolize(res)
    end

    # inspect an image
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/inspect.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when tag is not found.
    # @raise [Hyperb::Error::InternalServerError] server error on hyper side.
    #
    # @return [Hash] downcased symbolized `inspect` json response.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :name image name to be removed
    def inspect_image(params = {})
      path = '/images/' + params[:name] + '/json'
      res = JSON.parse(Hyperb::Request.new(self, path, {}, 'get').perform)
      downcase_symbolize(res)
    end
  end
end
