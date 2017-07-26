module Etherlite::Support
  module Array
    extend self

    def encode(_types, _values)
      head = []
      tail = []
      tail_offset = _types.sum(0) { |type| type.dynamic? ? 32 : type.size } # type.size is always 32

      _types.each_with_index do |type, i|
        content = type.encode _values[i]
        if type.dynamic?
          head << Etherlite::Utils.uint_to_hex(tail_offset)
          tail << content
          tail_offset += content.length / 2 # hex string, 2 characters per byte
        else
          head << content
        end
      end

      head.join + tail.join
    end

    def decode(_connection, _types, _data)
      words = _data.scan(/.{64}/)
      offset = 0

      [].tap do |r|
        _types.each do |type|
          if type.dynamic?
            offset_words = Etherlite::Utils.hex_to_uint(words[offset]) / 32
            r << type.decode(_connection, words[offset_words..-1].join)
            offset += 1
          else
            size_in_words = type.size / 32 # type.size is always 32
            r << type.decode(_connection, words.slice(offset, size_in_words).join)
            offset += size_in_words
          end
        end
      end
    end
  end
end
