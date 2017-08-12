module Etherlite::Contract
  class FunctionInput
    attr_reader :original_name, :type

    def initialize(_original_name, _type)
      @original_name = _original_name
      @type = _type
    end

    def signature
      @type.signature
    end

    def name
      @name ||= @original_name.underscore
    end
  end
end
