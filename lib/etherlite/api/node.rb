module Etherlite
  module Api
    module Node
      extend Forwardable
      include Address

      def get_block_number
        Etherlite::Utils.hex_to_uint connection.ipc_call(:eth_blockNumber)
      end

      def get_gas_price
        Etherlite::Utils.hex_to_uint connection.ipc_call(:eth_gasPrice)
      end

      def get_transaction_receipt(_tx_hash)
        connection.ipc_call(:eth_getTransactionReceipt, _tx_hash)
      end

      def register_account(_passphrase)
        address = connection.ipc_call(:personal_newAccount, _passphrase)
        Etherlite::Account.new @connection, Etherlite::Utils.normalize_address(address)
      end

      def accounts
        connection.ipc_call(:eth_accounts).map do |address|
          Etherlite::Account.new @connection, Etherlite::Utils.normalize_address(address)
        end
      end

      def first_account
        @first_account ||= accounts.first
      end

      def_delegators :first_account, :unlock, :lock, :normalized_address, :send_to, :call
    end
  end
end
