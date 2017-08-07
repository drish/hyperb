require 'hyperb/utils'

module Hyperb
  # container object
  class Container
    include Hyperb::Utils
    attr_accessor :id, :names, :image, :imageid,
                  :created, :command, :ports, :labels,
                  :sizerw, :sizerootfs, :state, :hostconfig,
                  :networksettings

    def initialize(attrs = {})
      attrs.each do |att, value|
        value = downcase_symbolize(value) if value.is_a?(Hash)
        instance_variable_set("@#{att.downcase.to_sym}", value)
      end
    end

    def name
      names.first
    end

    def running?
      state == 'running'
    end
  end
end
