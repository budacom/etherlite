require 'eth'

module Etherlite
  module Account
    class PrivateKey < Base
      def initialize(_connection, _pk)
        @key = Eth::Key.new priv: _pk
        super _connection, Etherlite::Utils.normalize_address(@key.address)
      end

      def send_transaction(_options = {})
        nonce_options = {
          replace: _options.fetch(:replace, false)
        }

        nonce_manager.with_next_nonce_for(normalized_address, nonce_options) do |nonce|
          tx = Eth::Tx.new(
            value: _options.fetch(:value, 0),
            data: _options.fetch(:data, ''),
            gas_limit: _options.fetch(:gas, 90_000),
            gas_price: _options.fetch(:gas_price, gas_price),
            to: (Etherlite::Utils.encode_address_param(_options[:to]) if _options.key?(:to)),
            nonce: nonce
          )

          # Since eth gem does not allow configuration of chains for every tx, we need
          # to globally configure it before signing. This is not thread safe so a mutex is needed.
          sign_with_connection_chain tx

          Etherlite::Transaction.new @connection, @connection.eth_send_raw_transaction(tx.hex)
        end
      end

      private

      @@eth_mutex = Mutex.new

      def gas_price
        # TODO: improve on this
        @gas_price ||= connection.eth_gas_price
      end

      def nonce_manager
        Etherlite::NonceManager.new @connection
      end

      def sign_with_connection_chain(_tx)
        @@eth_mutex.synchronize do
          Eth.configure { |c| c.chain_id = @connection.chain_id }
          _tx.sign @key
        end
      end
    end
  end
end
