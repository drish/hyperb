require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/funcs/func'

module Hyperb
  # funcs api wrapper
  module Funcs
    include Hyperb::Utils
    # list funcs
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::InternalServerError] raised hyper servers return 5xx.
    #
    # @return [Hyperb::Func] Array of Funcs.
    def funcs
      path = '/funcs'
      query = {}
      response = JSON.parse(Hyperb::Request.new(self, path, query, 'get').perform)
      response.map { |func| Hyperb::Func.new(func) }
    end

    # create a func
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/create.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::Conflict] raised when func already exist
    # @raise [Hyperb::Error::BadRequest] raised when a bad parameter is sent
    # @raise [Hyperb::Error::InternalServerError] server error on hyper side.
    # @raise [ArgumentError] when required arguments are not provided.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @param params :name [String] the function name.
    #
    # @param params :container_size [String] the size of containers
    # to run the function (e.g. s1,s2, s3, s4, m1, m2, m3, l1, l2, l3)
    #
    # @param params :timeout [String] default is 300 seconds, maximum is 86400 seconds.
    # @param params :uuid [String] The uuid of function.
    #
    # @param params :config [Hash] func configurations
    # @param params config :tty [Boolean] attach streams to a tty
    # @param params config :exposed_ports [Hash] an object mapping ports to an empty
    # object in the form of: "ExposedPorts": { "<port>/<tcp|udp>: {}" }
    # @param params config :env [Array] list of env vars, "VAR=VALUE"
    # @param params config :cmd [Array|String] list of env vars, "VAR=VALUE"
    # @param params config :image [String] image to run
    # @param params config :entrypoint [String] entrypoint
    # @param params config :working_dir [String] working directory
    # @param params config :labels [Hash] labels
    #
    # @param params :host_config [Hash] func host configurations
    # @param params host_config :links [Array] list of links
    # @param params host_config :port_bindings [Hash]
    # @param params host_config :publish_all_ports [Boolean]
    # @param params host_config :volumes_from [Array]
    # @param params host_config :network_mode [String]
    def create_func(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'name')
      path = '/funcs/create'

      body = {}
      body.merge!(prepare_json(params))

      Hyperb::Request.new(self, path, {}, 'post', body).perform
    end

    # remove a func
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Func/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    # @raise [Hyperb::Error::Conflict] raised when func with that name is running
    # @raise [Hyperb::Error::BadRequest] raised when a bad parameter is sent
    # @raise [Hyperb::Error::InternalServerError] server error on hyper side.
    # @raise [ArgumentError] when required arguments are not provided.
    #
    # @param params [Hash] A customizable set of params.
    #
    # @param params :name [String] the function name.
    def remove_func(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'name')
      path = '/funcs/' + params[:name]
      Hyperb::Request.new(self, path, {}, 'delete').perform
    end
  end
end
