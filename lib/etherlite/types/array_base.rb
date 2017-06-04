module Etherlite::Types
  class ArrayBase < Base
    attr_reader :subtype

    def initialize(_subtype)
      raise ArgumentError, 'An array can not contain a dynamic type' if _subtype.dynamic?
      @subtype = _subtype
    end

    private

    def encode_values(_values)
      if @subtype.dynamic?
        encode_dynamic _values
      else
        _values.map { |i| @subtype.encode(i) }.join
      end
    end

    def encode_dynamic(_values)
      offset = 32 * @size # initial header offset
      header = []
      tail = []

      _values.each do |item|
        encoded_item = @subtype.encode(item)

        header << Etherlite::Utils.uint_to_hex(offset)
        tail << encoded_item
        offset += encoded_item.length / 2 # hex string, 2 characters per byte
      end

      header.join + tail.join
    end
  end
end
