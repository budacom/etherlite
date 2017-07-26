module Etherlite::Types
  class ArrayDynamic < Base
    attr_reader :subtype

    def initialize(_subtype)
      raise ArgumentError, 'An array can not contain a dynamic type' if _subtype.dynamic?

      @subtype = _subtype
    end

    def signature
      "#{@subtype.signature}[]"
    end

    def encode(_values)
      raise ArgumentError, "expected an array for #{signature}" unless _values.is_a? Array

      encoded_array = Etherlite::Support::Array.encode([@subtype] * _values.length, _values)
      Etherlite::Utils.uint_to_hex(_values.length) + encoded_array
    end

    def decode(_connection, _data)
      length = Etherlite::Utils.hex_to_uint(_data[0..63])
      Etherlite::Support::Array.decode(_connection, [@subtype] * length, _data[64..-1])
    end
  end
end
