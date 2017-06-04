require 'etherlite/commands/abi/load_type'
require 'etherlite/commands/abi/load_contract'
require 'etherlite/commands/abi/load_function'

module Etherlite
  module Abi
    extend self

    def load_contract_at(_path)
      json = JSON.parse File.read(_path)
      LoadContract.for json: json
    end

    def load_contract(_json)
      LoadContract.for json: _json
    end

    def load_function(_signature)
      LoadFunction.for signature: _signature
    end
  end
end
