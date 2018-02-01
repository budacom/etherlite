module Etherlite::Types
  class Bytes < Base
    def initialize(_size)
      raise ArgumentError, "invalid byte size #{_size}" unless 0 < _size && _size <= 32
      @size = _size
    end

    def signature
      "bytes#{@size}"
    end

    def size
      32
    end

    def encode(_value)
      raise ArgumentError, "invalid argument type for 'bytes'" unless _value.is_a? ::String

      _value.unpack('H*').first.rjust(64, '0')
    end
  end
end
