require 'base64'

module Hyperb
  # helper for managing auth objects
  # used to authenticate into third party docker registries
  class AuthObject
    attr_accessor :username, :password, :email, :serveraddress

    def initialize(options = {})
      @username = options[:username] || ''
      @email = options[:email] || ''
      @serveraddress = options[:serveraddress] || ''
      @password = options[:password].is_a?(File) ? options[:password].read : options[:password]
    end

    # preserve this order
    def attrs
      {
        username: username,
        password: password,
        email: email,
        serveraddress: serveraddress
      }
    end

    def valid?
      attrs.values.none? { |atr| blank?(atr) }
    end

    def blank?(val)
      val.respond_to?(:empty?) ? val.empty? : !val
    end

    def encode
      Base64.urlsafe_encode64(attrs.to_json)
    end

    def build
      { x_registry_auth: encode }
    end
  end
end
