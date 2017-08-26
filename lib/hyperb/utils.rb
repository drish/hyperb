module Hyperb
  # utils functions
  module Utils
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

    # hyper.sh responses are capital camel cased json, ie:
    #
    # {"HostConfigs": "value"}
    #
    # this fn is used to format all hyper.sh api reponses
    def downcase_symbolize(obj)
      if obj.is_a? Hash
        return obj.each_with_object({}) do |(k, v), memo|
          memo.tap { |m| m[underscore(k)] = downcase_symbolize(v) }
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

    # based on http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-underscore
    #
    # underscores and symbolize a string
    # @param [String] word
    # @returns [String]
    def underscore(word)
      word
        .gsub(/([A-Z]+)([A-Z]+)([A-Z][a-z])/, '\12_\3')
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase.to_sym
    end
  end
end
