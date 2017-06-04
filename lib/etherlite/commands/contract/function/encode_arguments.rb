class Etherlite::Contract::Function
  class EncodeArguments < PowerTypes::Command.new(:subtypes, :values)
    def perform # rubocop:disable Metrics/MethodLength
      if @values.length != @subtypes.count
        raise ArgumentError, "Expected #{@subtypes.count} arguments, got #{@values.length} "
      end

      head = []
      tail = []
      tail_offset = calculate_head_offset

      @subtypes.each_with_index do |type, i|
        content = type.encode @values[i]
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

    private

    def calculate_head_offset
      @subtypes.inject(0) { |r, type| r + (type.dynamic? ? 32 : type.size) }
    end
  end
end
