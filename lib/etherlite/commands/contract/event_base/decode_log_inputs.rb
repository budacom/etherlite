class Etherlite::Contract::EventBase
  class DecodeLogInputs < PowerTypes::Command.new(:connection, :inputs, :json)
    def perform
      store_by_name non_indexed_inputs, non_indexed_values
      store_by_name indexed_inputs, indexed_values
      attributes
    end

    private

    def attributes
      @attributes ||= {}
    end

    def non_indexed_inputs
      @non_indexed_inputs ||= @inputs.select { |i| !i.indexed? }
    end

    def non_indexed_values
      Etherlite::Support::Array.decode(
        @connection, non_indexed_inputs.map(&:type), @json['data'][2..-1]
      )
    end

    def indexed_inputs
      @indexed_inputs ||= @inputs.select(&:indexed?)
    end

    def indexed_values
      topics = @json['topics'][1..-1]
      indexed_inputs.each_with_index.map do |input, i|
        # dynamic indexed inputs cannot be retrieved (only the hash is stored)
        input.type.dynamic? ? topics[i] : input.type.decode(@connection, topics[i])
      end
    end

    def store_by_name(_inputs, _values)
      _inputs.each_with_index { |input, i| attributes[input.original_name] = _values[i] }
    end
  end
end
