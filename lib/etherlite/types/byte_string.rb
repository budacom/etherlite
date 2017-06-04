module Etherlite::Types
  class ByteString < Base
    def signature
      "bytes"
    end

    def encode(_value)
      raise ArgumentError, "invalid argument type for 'bytes'" unless _value.is_a? ::String

      bytes_as_hex = _value.unpack('H*').first
      bytes = bytes_as_hex.length / 2
      padded_size = (bytes.to_f / 32).ceil * 32

      Etherlite::Utils.uint_to_hex(bytes) + bytes_as_hex.ljust(padded_size * 2, '0')
    end
  end
end
