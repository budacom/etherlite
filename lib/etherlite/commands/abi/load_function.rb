module Etherlite::Abi
  class LoadFunction < PowerTypes::Command.new(:signature)
    MATCHER = /^(payable|onchain|\w[\w\d]*) (\w[\w\d]*)\((.*?)\)$/

    def perform
      parts = MATCHER.match @signature
      raise ArgumentError, 'invalid method signature' if parts.nil?

      inputs = parts[3].split(',').map { |a| LoadType.for(signature: a.strip) }

      case parts[1]
      when 'payable'
        build parts[2], inputs, [], true, false
      when 'onchain'
        build parts[2], inputs, [], false, false
      else
        ouputs = parts[1] == 'void' ? [] : [LoadType.for(signature: parts[1])]
        build parts[2], inputs, ouputs, false, true
      end
    end

    private

    def build(*_args)
      Etherlite::Contract::Function.new *_args
    end
  end
end
