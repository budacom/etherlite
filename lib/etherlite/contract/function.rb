require 'etherlite/commands/contract/function/encode_arguments'
require 'etherlite/commands/contract/function/decode_arguments'

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
      signature_hash = Etherlite::Utils.sha3 signature
      encoded_inputs = EncodeArguments.for subtypes: @inputs, values: _values

      '0x' + signature_hash[0..7] + encoded_inputs
    end

    def decode(_connection, _data)
      return nil if @outputs.empty?

      result = DecodeArguments.for connection: _connection, subtypes: @outputs, hex_data: _data
      result.length > 1 ? result : result[0]
    end
  end
end
