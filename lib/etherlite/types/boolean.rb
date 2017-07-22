module Etherlite::Types
  class Boolean < Base
    TRUE = '0000000000000000000000000000000000000000000000000000000000000001'.freeze # 32 bytes
    FALSE = '0000000000000000000000000000000000000000000000000000000000000000'.freeze

    def signature
      "bool"
    end

    def size
      32
    end

    def encode(_value)
      unless _value.is_a?(TrueClass) || _value.is_a?(FalseClass)
        raise ArgumentError, "value must be a boolean for #{signature}"
      end

      _value ? TRUE : FALSE
    end

    def decode(_connection, _value)
      _value.hex > 0
    end
  end
end
