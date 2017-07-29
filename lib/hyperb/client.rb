require 'hyperb/api'

module Hyperb

  class Client
    include Hyperb::API

    attr_accessor :secret_key, :access_key

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def credentials
      {
        secret_key: secret_key,
        access_key: access_key
      }
    end

    def credentials?
      credentials.values.none? { |cred| blank?(cred) }
    end

    def blank?(val)
      val.respond_to?(:empty?) ? val.empty? : !val
    end
  end
end