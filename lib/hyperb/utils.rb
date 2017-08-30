module Hyperb
  # utils functions
  module Utils
    # converts from Symbol or String to CamelCase
    # @return String
    def camelize(value)
      value.to_s.split('_').collect(&:capitalize).join
    end

    # checks if all args are keys into the hash
    #
    # @return [Boolean]
    #
    # @param params [Hash] hash to check.
    # @option *args [String] array of strings to check against the hash
    def check_arguments(params, *args)
      contains = true
      args.each do |arg|
        contains = false unless params.key? arg.to_sym
      end
      contains
    end

    # hyper.sh responses are capital cased json
    #
    # {"Field": "value"}
    #
    # this fn is used to symbolize and downcase all hyper.sh api reponses
    def downcase_symbolize(obj)
      if obj.is_a? Hash
        return obj.each_with_object({}) do |(k, v), memo|
          memo.tap { |m| m[k.downcase.to_sym] = downcase_symbolize(v) }
        end
      end

      if obj.is_a? Array
        return obj.each_with_object([]) do |v, memo|
          memo << downcase_symbolize(v)
          memo
        end
      end
      obj
    end
  end
end
