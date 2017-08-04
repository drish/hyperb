require 'hyperb/utils'

module Hyperb

	class Container

    include Hyperb::Utils
    attr_accessor :id, :names, :image, :image_id,
                  :created, :command, :ports, :labels,
                  :size_rw, :size_root_fs, :state, :host_config,
                  :network_settings

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