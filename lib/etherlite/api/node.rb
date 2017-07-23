module Etherlite
  module Api
    module Node
      extend Forwardable
      include Address

      def get_block_number
        connection.eth_block_number
      end

      def get_gas_price
        connection.eth_gas_price
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

      def account_from_pk(_pk)
        Etherlite::PkAccount.new(connection, _pk)
      end

      def_delegators :first_account, :unlock, :lock, :normalized_address, :transfer_to, :call
    end
  end
end
