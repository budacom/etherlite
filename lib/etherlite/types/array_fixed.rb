module Etherlite::Types
  class ArrayFixed < ArrayBase
    def initialize(_subtype, _size)
      super _subtype
      @size = _size
    end

    def signature
      "#{subtype.signature}[#{@size}]"
    end

    def size
      subtype.size * @size
    end

    def encode(_value)
      raise ArgumentError, "expected an array for #{signature}" unless _value.is_a? Array
      raise ArgumentError, "expected array of size #{@size}" unless _value.size == @size

      encode_values _value
    end
  end
end
