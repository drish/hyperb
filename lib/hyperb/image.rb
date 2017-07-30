module Hyperb

	class Image

    attr_accessor :id, :parent_id, :repo_tags, :repo_digests,
                  :created, :size, :labels, :virtual_size

    def initialize(attrs = {})
      attrs.each do |k, v|
        instance_variable_set("@#{k.downcase.to_sym}", v)
      end
    end
  end
end