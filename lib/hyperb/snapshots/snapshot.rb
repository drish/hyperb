module Hyperb
  # snapshot object
  class Snapshot
    attr_accessor :id, :name, :size, :volume

    def initialize(attrs = {})
      attrs.each do |k, v|
        instance_variable_set("@#{k.downcase.to_sym}", v)
      end
    end
  end
end
