module Etherlite::Types
  class Fixed < Base
    def initialize(_signed, _size_m, _size_n)
      unless 0 < (_size_m + _size_n) && (_size_m + _size_n) <= 256 &&
          _size_m % 8 == 0 && _size_n % 8 == 0
        raise ArgumentError, "invalid fixed size #{_size_m}x#{_size_n}"
      end

      @signed = _signed
      @size_m = _size_m
      @size_n = _size_n
    end

    def size
      32
    end

    def signature
      "#{@signed ? 'fixed' : 'ufixed'}#{@size_m}x#{@size_n}"
    end

    def encode(_value)
      raise ArgumentError, "expected a number for #{signature}" unless _value.is_a? Numeric
      raise ArgumentError, "expected a positive number for #{signature}" if !@signed && _value < 0

      norm_value = (_value * (2**@size_n)).floor
      raise ArgumentError, "value out of bounds #{_value}" if norm_value.abs > maximum

      @signed ? Etherlite::Utils.int_to_hex(norm_value) : Etherlite::Utils.uint_to_hex(norm_value)
    end

    private

    def maximum
      2**(@signed ? (@size_m + @size_n) - 1 : (@size_m + @size_n))
    end
  end
end
