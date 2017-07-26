class Etherlite::Contract::Function
  class DecodeArguments < PowerTypes::Command.new(:connection, :subtypes, :hex_data)
    def perform
      [].tap do |r|
        word_idx = 0
        @subtypes.each do |type|
          if type.dynamic?
            word_count = 1
            offset_words = Etherlite::Utils.hex_to_uint(words[word_idx]) / 32

            # not sure about the length of the content at this point, send everything to type
            r << type.decode(@connection, words[offset_words..-1].join)
          else
            word_count = type.size / 32
            r << type.decode(@connection, words[word_idx..word_idx + word_count].join)
          end

          word_idx += word_count
        end
      end
    end

    def words
      @words ||= @hex_data[2..-1].scan(/.{64}/)
    end
  end
end
