module Etherlite::Account
  class Base
    include Etherlite::Api::Address

    attr_reader :connection, :normalized_address

    def initialize(_connection, _normalized_address = nil)
      @connection = _connection
      @normalized_address = _normalized_address
    end

    ##
    # Send wei to an account/contract
    #
    # @param _target (String) The address to send wei to.
    #
    # This method also takes the following keyword arguments
    #
    # @param amount (Integer) The amount of wei to send.
    # @param gas (Integer) Optional transaction gas limit override.
    # @param gas_price (Integer) Optional transaction gas price override in wei.
    # @param data (String) Optional data to send with transaction, in hex.
    #
    # @return [Etherlite::Transaction]
    #
    def transfer_to(_target, _options = {})
      send_transaction _options.merge(to: _target, value: _options.fetch(:amount, 0))
    end

    ##
    # Call a contract's method
    #
    # @param _target (String) The address of the contract.
    # @param _function (String|Etherlite::Contract::Function) The function to call.
    # @param _params (Mixed) The arguments to pass to the function, must match with 
    # function prototype.
    #
    # This method also takes the following keyword arguments
    #
    # @param pay (Integer) The amount of wei to send with this call. (only payable)
    # @param gas (Integer) Optional transaction gas limit override. (only non-constant)
    # @param gas_price (Integer) Optional transaction gas price override in wei. (only non-constant)
    # @param data (String) Optional data to send with transaction, in hex. (only non-constant)
    #
    # @return [Etherlite::Transaction|Mixed] For non-constant functions, this method will 
    # return a transaction. For constant functions, this method will return the value returned
    # by the call.
    #
    def call(_target, _function, *_params)
      _function = parse_function(_function) if _function.is_a? String
      options = _params.last.is_a?(Hash) ? _params.pop.clone : {}

      if _function.constant?
        call_constant _target, _function, _params, options
      else
        value = options.fetch(:pay, 0)
        raise 'function is not payable' if value > 0 && !_function.payable?

        send_transaction options.merge(
          to: _target, data: _function.encode(_params), value: value
        )
      end
    end

    def send_transaction(_options = {})
      raise NotSupportedError, 'transactions are not supported by this kind of account'
    end

    private

    def call_constant(_target, _function, _params, _options)
      params = {
        from: json_encoded_address,
        to: Etherlite::Utils.encode_address_param(_target),
        data: _function.encode(_params)
      }

      params[:from] = json_encoded_address if @normalized_address.present?

      block = Etherlite::Utils.encode_block_param _options.fetch(:block, :latest)

      _function.decode @connection, @connection.eth_call(params, block)
    end

    def parse_function(_signature)
      Abi::LoadFunction.for signature: _signature
    end
  end
end
