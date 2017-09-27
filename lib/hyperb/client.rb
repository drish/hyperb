require 'hyperb/api'
require 'hyperb/error'

module Hyperb
  # client class
  class Client
    include Hyperb::API

    REGIONS = [
      'us-west-1',
      'eu-central-1'
    ].freeze

    attr_accessor :secret_key, :access_key, :region

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      validate_and_set_region
      yield(self) if block_given?
    end

    def validate_and_set_region
      if @region.nil?
        @region = default_region
      else
        raise Hyperb::Error::UnsupportedRegion, @region.to_s unless supported_region?(@region)
      end
    end

    def default_region
      REGIONS.first
    end

    def supported_region?(region)
      REGIONS.include?(region.to_s)
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
