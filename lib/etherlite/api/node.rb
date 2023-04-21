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

      def get_transaction(*_args)
        load_transaction(*_args).refresh
      end

      def get_logs(events: nil, address: nil, from_block: :earliest, to_block: :latest)
        params = {
          fromBlock: Etherlite::Utils.encode_block_param(from_block),
          toBlock: Etherlite::Utils.encode_block_param(to_block)
        }

        params[:topics] = [Array(events).map(&:topic)] unless events.nil?
        params[:address] = Etherlite::Utils.encode_address_param(address) unless address.nil?

        logs = connection.ipc_call(:eth_getLogs, params)
        ::Etherlite::EventProvider.parse_raw_logs(connection, logs)
      end

      def load_transaction(_hash)
        Transaction.new(connection, _hash)
      end

      def load_account(from_pk: nil)
        Etherlite::Account::PrivateKey.new connection, from_pk
      end

      def load_address(_address)
        Etherlite::Address.new(connection, Etherlite::Utils.normalize_address_param(_address))
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
        @default_account ||= (accounts.first || anonymous_account)
      end

      def anonymous_account
        @anonymous_account ||= Etherlite::Account::Anonymous.new(connection)
      end

      def_delegators :default_account, :unlock, :lock, :normalized_address, :transfer_to, :call
    end
  end
end
