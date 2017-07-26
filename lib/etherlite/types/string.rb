module Etherlite::Types
  class String < ByteString
    def signature
      "string"
    end

    def encode(_value)
      super _value.encode('UTF-8')
    end

    def decode(_connection, _value)
      super(_connection, _value).force_encoding("utf-8")
    end
  end
end
