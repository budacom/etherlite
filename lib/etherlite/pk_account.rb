require 'eth'

module Etherlite
  class PkAccount
    include Etherlite::Api::Address

    attr_reader :connection

    def initialize(_connection, _pk)
      @connection = _connection
      @key = Eth::Key.new priv: _pk
    end

    def normalized_address
      @normalized_address ||= Utils.normalize_address @key.address
    end

    def transfer_to(_target, _options = {})
      send_transaction(
        _options.fetch(:amount, 0), '', Utils.encode_address_param(_target), _options
      )
    end

    def call(_target, _function, *_params)
      _function = parse_function(_function) if _function.is_a? String
      options = _params.last.is_a?(Hash) ? _params.pop : {}

      if _function.constant?
        call_constant _target, _function, _params, options
      else
        value = options.fetch(:pay, 0)
        raise 'function is not payable' if value > 0 && !_function.payable?

        send_transaction(
          value, _function.encode(_params), Utils.encode_address_param(_target), options
        )
      end
    end

    private

    @@eth_mutex = Mutex.new

    def call_constant(_target, _function, _params, _options)
      ipc_params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        data: _function.encode(_params)
      }

      block = Utils.encode_block_param _options.fetch(:block, :latest)

      _function.decode @connection, @connection.eth_call(ipc_params, block)
    end

    def send_transaction(_value, _hex_data, _hex_address, _options)
      nonce_manager.with_next_nonce_for(normalized_address) do |nonce|
        tx = Eth::Tx.new(
          value: _value,
          data: _hex_data,
          gas_limit: _options.fetch(:gas, 90_000),
          gas_price: _options.fetch(:gas_price, gas_price),
          to: _hex_address,
          nonce: nonce
        )

        # Since eth gem does not allow configuration of chains for every tx, we need
        # to globally configure it before signing. This is not thread safe so a mutex is needed.
        sign_with_connection_chain tx

        Transaction.new @connection, @connection.eth_send_raw_transaction(tx.hex)
      end
    end

    def gas_price
      # TODO: improve on this
      @gas_price ||= connection.eth_gas_price
    end

    def nonce_manager
      NonceManager.new @connection
    end

    def sign_with_connection_chain(_tx)
      @@eth_mutex.synchronize do
        Eth.configure { |c| c.chain_id = @connection.chain_id }
        _tx.sign @key
      end
    end

    def parse_function(_signature)
      Abi::LoadFunction.for signature: _signature
    end
  end
end
