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
      _function = Utils.parse_function(_function) unless _function.is_a? Contract::Function
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

    def call_constant(_target, _function, _params, _options)
      ipc_params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        data: _function.encode(_params)
      }

      block = Utils.encode_block_param _options.fetch(:block, :latest)

      _function.decode @connection, @connection.ipc_call(:eth_call, ipc_params, block)
    end

    def send_transaction(_value, _hex_data, _hex_address, _opt)
      nonce_manager.with_next_nonce_for(@key.address) do |nonce|
        tx = Eth::Tx.new(
          value: _value,
          data: _hex_data,
          gas_limit: _opt.fetch(:gas, 90_000),
          gas_price: _opt.fetch(:gas_price, gas_price),
          to: _hex_address,
          nonce: nonce
        )

        tx.sign @key

        @connection.ipc_call(:eth_sendRawTransaction, tx.hex)
      end
    end

    def gas_price
      # TODO: improve on this
      @gas_price ||= Etherlite::Utils.hex_to_uint @connection.ipc_call(:eth_gasPrice)
    end

    def nonce_manager
      NonceManager.new @connection
    end
  end
end
