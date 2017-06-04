module Etherlite::Abi
  class LoadFunction < PowerTypes::Command.new(:signature)
    MATCHER = /^(payable|onchain|\w[\w\d]*) (\w[\w\d]*)\((.*?)\)$/

    def perform
      parts = MATCHER.match @signature
      raise ArgumentError, 'invalid method signature' if parts.nil?

      args = parts[3].split(',').map { |a| LoadType.for(signature: a.strip) }

      case parts[1]
      when 'payable'
        build parts[2], args, payable: true
      when 'onchain'
        build parts[2], args
      else
        return_type = parts[1] == 'void' ? nil : LoadType.for(signature: parts[1])
        build parts[2], args, constant: true, returns: return_type
      end
    end

    private

    def build(*_args)
      Etherlite::Contract::Function.new *_args
    end
  end
end
