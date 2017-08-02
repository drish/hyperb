require 'hyperb/request'
require 'hyperb/image'
require 'hyperb/utils'
require 'json'
require 'base64'

module Hyperb
	module Images

    include Hyperb::Utils
    # list images
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hyperb::Image] Array of Images.
    # @param params [Hash] A customizable set of params.
    # @option params [String] :all
    # TODO: @option params [String] :filter only return images with the specified name
    # TODO: @option params [Hash] :filters a JSON encoded value of the filters to process on the images list.
    # TODO: @option params filters [String] :dangling true/false
    def images(params = {})
      path = '/images/json'
      path.concat('?all=true') if params[:all]
      response = JSON.parse(Hyperb::Request.new(self, path, 'get').perform)
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
    #
    # TODO: @option params [Boolean] :stdout print stream to stdout
    def create_image(params = {})
      raise ArgumentError.new('Invalid arguments.') if !check_arguments(params, 'from_image')
      path = '/images/create'
      path.concat("?fromImage=#{params[:from_image]}")
      path.concat("&tag=#{params[:tag]}") if params[:tag]
      additional_headers = {}
      additional_headers[:x_registry_auth] = Base64.urlsafe_encode64(params[:x_registry_auth].to_json) if params.has_key?(:x_registry_auth)
      res = Hyperb::Request.new(self, path, 'post', '', additional_headers).perform
      res
    end

    # remove an image
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Image/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when tag is not found.
    # @raise [Hyperb::Error::InternalServerError] server error on hyper side.
    #
    # @return [Array] array of downcase symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :name image name to be removed
    # @option params [Boolean] :force force image to be removed
    def remove_image(params = {})
      path = '/images/' + params[:name]
      path.concat('?force=true') if params[:force]
      res = JSON.parse(Hyperb::Request.new(self, path, 'delete').perform)
      downcase_symbolize(res)
    end

  end
end