module Etherlite::Types
  class ArrayDynamic < ArrayBase
    def signature
      "#{subtype.signature}[]"
    end

    def encode(_value)
      raise ArgumentError, "expected an array for #{signature}" unless _value.is_a? Array

      Etherlite::Utils.uint_to_hex(_value.size) + encode_values(_value)
    end
  end
end
