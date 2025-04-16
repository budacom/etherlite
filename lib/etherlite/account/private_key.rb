require 'eth'

module Etherlite
  module Account
    class PrivateKey < Base
      def initialize(_connection, _pk)
        @key = Eth::Key.new priv: _pk
        super _connection, Etherlite::Utils.normalize_address(@key.address.to_s)
      end

      def build_raw_transaction(_options = {})
        nonce = nonce_manager.next_nonce_for(normalized_address, **_options.slice(:replace, :nonce))

        tx = Eth::Tx.new(
          chain_id: @connection.chain_id,
          value: _options.fetch(:value, 0),
          data: _options.fetch(:data, ''),
          gas_limit: _options.fetch(:gas, 90_000),
          gas_price: _options.fetch(:gas_price, gas_price),
          to: (Etherlite::Utils.encode_address_param(_options[:to]) if _options.key?(:to)),
          nonce: nonce
        )

        tx.sign @key
        tx
      end

      def send_transaction(_options = {})
        tx = build_raw_transaction(_options)

        nonce_manager.with_next_nonce_for(normalized_address, nonce: tx.signer_nonce) do |_|
          Etherlite::Transaction.new @connection, @connection.eth_send_raw_transaction("0x#{tx.hex}")
        end
      end

      private

      def gas_price
        # TODO: improve on this
        @gas_price ||= connection.eth_gas_price
      end

      def nonce_manager
        Etherlite::NonceManager.new @connection
      end
    end
  end
end
