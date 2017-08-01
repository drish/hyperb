module Hyperb

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
        if !params.has_key? arg.to_sym
          contains = false
          break
        end
      end
      contains
    end

    # hyper.sh responses are capital cased json
    #
    # {"Field": "value"}
    #
    # this fn is used to symbolize and downcase all hyper.sh api reponses
    def downcase_symbolize(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.downcase.to_sym] = downcase_symbolize(v) }
      end if obj.is_a? Hash

      return obj.reduce([]) do |memo, v|
        memo << downcase_symbolize(v); memo
      end if obj.is_a? Array

      obj
    end

  end
end