require 'etherlite/commands/abi/load_type'
require 'etherlite/commands/abi/load_contract'
require 'etherlite/commands/abi/load_function'

module Etherlite
  ##
  # A set of ABI related utilities
  #
  module Abi
    extend self

    ##
    # Load a contract artifact file.
    #
    # This method parses a truffle artifact file and loads a **contract** class that inherits
    # from `Etherlite::Contract::Base`.
    #
    # The generated contract class exposes a series of methods to interact with an instance
    # of the contract described by the artifact.
    #
    # ```
    # contract_class = Etherlite::Abi.load_contract_at('/path/to/Contract.json')
    # instance = contract_class.deploy(gas: 1000000)
    # ```
    #
    # @param _path (String) The artifact file absolute path
    #
    # @return [Object] the generated contract class.
    #
    def load_contract_at(_path)
      artifact = JSON.parse File.read(_path)
      LoadContract.for artifact: artifact
    end

    ##
    # This method is similar to `load_contract_at` but takes a hash instead of the raw file.
    #
    # @param _artifact (Hash) The artifact hash
    #
    # @return [Object] the generated contract class.
    #
    def load_contract(_artifact)
      LoadContract.for artifact: _artifact
    end

    ##
    # This method is used internally to load a function definition given a function signature.
    #
    # The function definition can be later used to call a contract's function without need of
    # the artifact file.
    #
    # @param _signature (String) A string that matches:
    #
    #   (payable|onchain|<type>) <name>(<type>, <type>, ...), where <name> is the function's name
    #   and <type> is any valid solidity type.
    #
    # @return [Object] the generated function definition.
    #
    def load_function(_signature)
      LoadFunction.for signature: _signature
    end
  end
end
