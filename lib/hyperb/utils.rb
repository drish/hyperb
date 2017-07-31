module Hyperb

  module Utils

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