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

    # hyper.sh responses are capital camel cased json, ie:
    #
    # {"HostConfigs": "value"}
    #
    # this fn is used to format all hyper.sh api reponses
    def downcase_symbolize(obj)
      if obj.is_a? Hash
        return obj.each_with_object({}) do |(k, v), memo|
          memo.tap { |m| m[underscore(k).to_sym] = downcase_symbolize(v) }
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

    # prepares all json payloads before sending to hyper
    #
    # input: { foo_bar: 'test' }
    # output: {'FooBar': 'test' }
    def prepare_json(params = {})
      json = {}
      params.each do |key, value|
        value = prepare_json(value) if value.is_a?(Hash)
        json[camelize(key)] = value
      end
      json
    end

    # based on http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-underscore
    #
    # underscores and symbolize a string
    # @param [String] word
    # @returns [Symbol]
    def underscore(camel_cased_word)
      return camel_cased_word unless camel_cased_word =~ /[A-Z-]|::/
      word = camel_cased_word.to_s.gsub(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      word.tr!('-', '_')
      word.downcase!
      word.to_sym
    end
  end
end
