module Hyperb
  # func object
  class Func
    attr_accessor :name, :container_size, :timeout, :uuid,
                  :created, :config, :host_config, :networking_config

    def initialize(attrs = {})
      attrs.each do |k, v|
        instance_variable_set("@#{k.downcase.to_sym}", v)
      end
    end
  end
end
