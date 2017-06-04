module Etherlite::Types
  class Integer < Base
    def initialize(_signed, _size)
      unless 0 < _size && _size <= 256 && _size % 8 == 0
        raise ArgumentError, "invalid integer size #{_size}"
      end

      @signed = _signed
      @size = _size
    end

    def signature
      "#{@signed ? 'int' : 'uint'}#{@size}"
    end

    def size
      32
    end

    def encode(_value)
      raise ArgumentError, "expected a number for #{signature}" unless _value.is_a? ::Integer
      raise ArgumentError, "expected a positive number for #{signature}" if !@signed && _value < 0
      raise ArgumentError, "value out of bounds #{_value}" if _value.abs > maximum

      @signed ? Etherlite::Utils.int_to_hex(_value) : Etherlite::Utils.uint_to_hex(_value)
    end

    def decode(_connection, _value)
      @signed ? Etherlite::Utils.hex_to_int(_value) : Etherlite::Utils.hex_to_uint(_value)
    end

    private

    def maximum
      2**(@signed ? @size - 1 : @size)
    end
  end
end
