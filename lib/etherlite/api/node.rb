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
        Etherlite::Account::Local.new @connection, Etherlite::Utils.normalize_address(address)
      end

      def accounts
        connection.ipc_call(:eth_accounts).map do |address|
          Etherlite::Account::Local.new @connection, Etherlite::Utils.normalize_address(address)
        end
      end

      def default_account
        @default_account ||= load_default_account
      end

      def account_from_pk(_pk)
        Etherlite::Account::PrivateKey.new connection, _pk
      end

      def_delegators :default_account, :unlock, :lock, :normalized_address, :transfer_to, :call

      private

      def load_default_account
        # TODO: consider configuring a global PK and allow the default account to use it
        accounts.first || Etherlite::Account::Anonymous.new(connection)
      end
    end
  end
end
