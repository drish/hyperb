require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/auth_object'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # network api wrapper
  module Network
    include Hyperb::Utils

    # detach a floating ip from a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Network/fip_detach.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when container is found.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :container
    def fip_detach(params = {})
      raise ArgumentError, 'Invalid Arguments' unless check_arguments(params, 'container')
      path = '/fips/detach'
      query = {}
      query[:container] = params[:container] if params.key?(:container)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # attach a floating ip to a container
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Network/fip_attach.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when ip are not found.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :ip
    # @option params [String] :container
    def fip_attach(params = {})
      raise ArgumentError, 'Invalid Arguments' unless check_arguments(params, 'container', 'ip')
      path = '/fips/attach'
      query = {}
      query[:ip] = params[:ip] if params.key?(:ip)
      query[:container] = params[:container] if params.key?(:container)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # list floating ips
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Network/fip_ls.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when ips are not found.
    #
    # @returns [Array] array of downcased symbolized has
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :filters
    def fips_ls(params = {})
      path = '/fips'
      query = {}
      query[:filters] = params[:filters] if params.key?(:filters)
      downcase_symbolize(JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform))
    end

    # release a floating ip
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Network/fip_release.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::NotFound] raised when ips are not found.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :ip the number of free fips to allocate
    def fip_release(params = {})
      path = '/fips/release'
      query = {}
      query[:ip] = params[:ip] if params.key?(:ip)
      Hyperb::Request.new(self, path, query, 'post').perform
    end

    # allocate a new floating ip
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Network/fip_allocate.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Array] Array of ips (string).
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :count the number of free fips to allocate
    def fip_allocate(params = {})
      raise ArgumentError, 'Invalid Arguments' unless check_arguments(params, 'count')
      path = '/fips/allocate'
      query = {}
      query[:count] = params[:count] if params.key?(:count)
      fips = JSON.parse(Hyperb::Request.new(self, path, query, 'post').perform)
      fips
    end
  end
end
