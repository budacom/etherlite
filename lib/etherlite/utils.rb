require "etherlite/commands/utils/validate_address"

module Etherlite
  module Utils
    extend self

    def sha3(_data)
      Digest::Keccak.hexdigest(_data, 256)
    end

    def uint_to_hex(_value, bytes: 32)
      _value.to_s(16).rjust(bytes * 2, '0')
    end

    def int_to_hex(_value, bytes: 32)
      if _value.negative?
        # 2's complement for negative values
        (_value & ((1 << bytes * 8) - 1)).to_s(16)
      else
        uint_to_hex(_value, bytes: bytes)
      end
    end

    def hex_to_uint(_hex_value)
      _hex_value.hex
    end

    def hex_to_int(_hex_value, bytes: 32)
      value = _hex_value.hex
      top_bit = (1 << (bytes * 8 - 1))
      (value & top_bit).positive? ? (value - 2 * top_bit) : value
    end

    def valid_address?(_address)
      ValidateAddress.for(address: _address)
    end

    def normalize_address(_value)
      _value.gsub(/^0x/, '').downcase
    end

    def normalize_address_param(_value)
      if _value.respond_to? :normalized_address
        _value.normalized_address
      else
        _value = _value.to_s
        raise ArgumentError, 'invalid address' unless valid_address? _value

        normalize_address _value
      end
    end

    def encode_address_param(_value)
      "0x#{normalize_address_param(_value)}"
    end

    def encode_block_param(_value)
      return _value.to_s if ['pending', 'earliest', 'latest'].include?(_value.to_s)

      "0x#{_value.to_s(16)}"
    end

    def encode_quantity_param(_value)
      "0x#{_value.to_s(16)}"
    end
  end
end
