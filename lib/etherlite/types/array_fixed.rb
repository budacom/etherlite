module Etherlite::Types
  class ArrayFixed < Base
    attr_reader :length, :subtype

    def initialize(_subtype, _length)
      raise ArgumentError, 'An array can not contain a dynamic type' if _subtype.dynamic?

      @subtype = _subtype
      @length = _length
    end

    def signature
      "#{@subtype.signature}[#{@length}]"
    end

    def size
      return nil if @subtype.dynamic?
      @subtype.size * @length
    end

    def encode(_values)
      raise ArgumentError, "expected an array for #{signature}" unless _values.is_a? Array
      raise ArgumentError, "expected array of length #{@length}" unless _values.length == @length

      Etherlite::Support::Array.encode([@subtype] * @length, _values)
    end

    def decode(_connection, _data)
      Etherlite::Support::Array.decode(_connection, [@subtype] * @length, _data)
    end
  end
end
