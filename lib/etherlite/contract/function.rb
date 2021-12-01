module Etherlite::Contract
  class Function
    attr_reader :name, :inputs, :outputs

    def initialize(_name, _inputs, _outputs, _payable, _constant)
      @name = _name
      @inputs = _inputs
      @outputs = _outputs

      @payable = _payable
      @constant = _constant
    end

    def constant?
      @constant
    end

    def payable?
      @payable
    end

    def signature
      @signature ||= begin
        arg_signatures = @inputs.map &:signature
        "#{@name}(#{arg_signatures.join(',')})"
      end
    end

    def encode(_values)
      if _values.length != @inputs.count
        raise ArgumentError, "Expected #{@inputs.count} arguments, got #{_values.length} "
      end

      encoded_inputs = Etherlite::Support::Array.encode(@inputs.map(&:type), _values)

      if @name
        signature_hash = Etherlite::Utils.keccak signature
        '0x' + signature_hash[0..7] + encoded_inputs
      else
        encoded_inputs # if no name is provided, just render arguments
      end
    end

    def decode(_connection, _data)
      return nil if @outputs.empty?

      result = Etherlite::Support::Array.decode(_connection, @outputs, _data[2..-1])
      result.length > 1 ? result : result[0]
    end
  end
end
