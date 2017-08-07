require 'hyperb/utils'

module Hyperb
  # volume object
  class Volume
    include Hyperb::Utils
    attr_accessor :name, :driver, :mountpoint, :labels

    def initialize(attrs = {})
      attrs.each do |att, value|
        value = downcase_symbolize(value) if value.is_a?(Hash)
        instance_variable_set("@#{att.downcase.to_sym}", value)
      end
    end
  end
end
