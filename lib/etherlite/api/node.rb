module Etherlite
  module Api
    module Node
      extend Forwardable
      include Address

      # Gets the las block number seen by this node
      def get_block_number
        connection.eth_block_number
      end

      # Gets the current gas price in wei
      def get_gas_price
        connection.eth_gas_price
      end

      ##
      # Registers a new account in this node (requires personal access)
      #
      # @param _passphrase (String) The new account passphrase
      #
      # @return [Etherlite::Account::Local] The new account instance  
      #
      def register_account(_passphrase)
        address = connection.ipc_call(:personal_newAccount, _passphrase)
        Etherlite::Account::Local.new @connection, Etherlite::Utils.normalize_address(address)
      end

      ##
      # Gets the accounts managed by this node
      #
      # @return [Array<Etherlite::Account::Local>] All accounts 
      #
      def accounts
        connection.ipc_call(:eth_accounts).map do |address|
          Etherlite::Account::Local.new @connection, Etherlite::Utils.normalize_address(address)
        end
      end

      ##
      # Gets this node default account
      #
      # Any operation that requires an account and is called without specifting one will
      # use the default account. 
      #
      def default_account
        @default_account ||= load_default_account
      end

      ##
      # Loads an account given its private key.
      #
      # Private key is not send to the node, every transaction is signed locally using the `eth` gem. 
      #
      # @param _pk (String) The private key as an hex string.
      #
      # @return [Etherlite::Account::PrivateKey] The account instance
      #
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
