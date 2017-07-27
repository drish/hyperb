module Hyperb
  class Client

    attr_accessor :secret_key, :access_key

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end


    def credentials
      {
        secret_key: secret_key,
        access_key: access_key
      }
    end

    def credentials?
      !credentials.values.none?
    end

    def blank?(val)
      val.respond_to?(:empty?) ? val.empty? : !val
    end
  end
end