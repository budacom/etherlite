module Etherlite::Types
  class Base
    def signature
      raise NotImplementedError, 'signature must be implemented by base type'
    end

    def size
      nil
    end

    def fixed?
      !size.nil?
    end

    def dynamic?
      size.nil?
    end

    def encode(_value)
      raise NotImplementedError, 'encode must be implemented by base type'
    end

    def decode(_connection, _value)
      '0x' + _value
    end
  end
end
