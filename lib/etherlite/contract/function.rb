require 'etherlite/commands/contract/function/encode_arguments'

module Etherlite::Contract
  class Function
    attr_reader :name, :args

    def initialize(_name, _args, returns: nil, payable: false, constant: false)
      @name = _name
      @args = _args

      @returns = returns
      @payable = payable
      @constant = constant
    end

    def constant?
      @constant
    end

    def payable?
      @payable
    end

    def signature
      @signature ||= begin
        arg_signatures = @args.map &:signature
        "#{@name}(#{arg_signatures.join(',')})"
      end
    end

    def encode(_values)
      signature_hash = Etherlite::Utils.sha3 signature
      encoded_args = EncodeArguments.for subtypes: @args, values: _values

      '0x' + signature_hash[0..7] + encoded_args
    end

    def decode(_connection, _values)
      # TODO: decode return values
      _values
    end
  end
end
