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
    end
  end
end
