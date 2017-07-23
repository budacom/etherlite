module Etherlite
  class Account
    include Etherlite::Api::Address

    attr_reader :connection, :normalized_address

    def initialize(_connection, _normalized_address)
      @connection = _connection
      @normalized_address = _normalized_address
    end

    def unlock(_passphrase)
      @passphrase = _passphrase
    end

    def lock
      @passphrase = nil
    end

    def transfer_to(_target, _options = {})
      params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        value: Utils.encode_quantity_param(_options.fetch(:amount, 0))
      }

      send_transaction params, _options
    end

    def call(_target, _function, *_params)
      _function = parse_function(_function) if _function.is_a? String
      options = _params.last.is_a?(Hash) ? _params.pop : {}

      if _function.constant?
        call_constant _target, _function, _params, options
      else
        send_function_transaction _target, _function, _params, options
      end
    end

    private

    attr_reader :normalized_address

    def call_constant(_target, _function, _params, _options)
      ipc_params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        data: _function.encode(_params)
      }

      block = Utils.encode_block_param _options.fetch(:block, :latest)

      _function.decode @connection, @connection.ipc_call(:eth_call, ipc_params, block)
    end

    def send_function_transaction(_target, _function, _params, _options)
      ipc_params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        data: _function.encode(_params)
      }

      value = _options.fetch(:pay, 0)
      raise 'function is not payable' if value > 0 && !_function.payable?
      ipc_params[:value] = value

      send_transaction(ipc_params, _options)
    end

    def send_transaction(_params, _opt)
      _params[:gas] = Utils.encode_quantity_param(_opt[:gas]) if _opt.key? :gas
      _params[:gasPrice] = Utils.encode_quantity_param(_opt[:gas_price]) if _opt.key? :gas_price

      passphrase = _opt.fetch(:passphrase, @passphrase)
      tx_hash = if passphrase.nil?
                  @connection.ipc_call(:eth_sendTransaction, _params)
                else
                  @connection.ipc_call(:personal_sendTransaction, _params, passphrase)
                end

      Transaction.new @connection, tx_hash
    end

    def parse_function(_signature)
      Abi::LoadFunction.for signature: _signature
    end
  end
end
