module Etherlite::Types
  class Address < Base
    def signature
      "address" # not sure about this
    end

    def size
      32
    end

    def encode(_value)
      _value = Etherlite::Utils.normalize_address_param _value
      _value.to_raw_hex.rjust(64, '0')
    end

    def decode(_connection, _value)
      Etherlite::Address.new _connection, _value[24..-1].downcase
    end
  end
end
