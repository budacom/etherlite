require 'etherlite/commands/abi/load_type'
require 'etherlite/commands/abi/load_contract'
require 'etherlite/commands/abi/load_function'

module Etherlite
  module Abi
    extend self

    def load_contract_at(_path)
      load_contract JSON.parse File.read(_path)
    end

    def load_contract(_json)
      LoadContract.for artifact: _json
    end

    def load_function(_signature)
      LoadFunction.for signature: _signature
    end
  end
end
