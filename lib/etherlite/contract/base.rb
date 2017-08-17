module Etherlite::Contract
  ##
  # The base class for etherlite contract classes.
  #
  class Base
    include Etherlite::Api::Address

    # The contract's registered functions
    def self.functions
      @functions ||= []
    end

    # The contract's registered events
    def self.events
      @events ||= []
    end

    # The contract's unlinked bytecode
    def self.unlinked_binary
      '0x0'
    end

    # The contract's constructor function definition
    def self.constructor
      nil
    end

    # The contract's compiled bytecode in binary format (stored as hex)
    def self.binary
      @binary ||= begin
        if /__[^_]+_+/ === unlinked_binary
          raise UnlinkedContractError, 'compiled contract contains unresolved library references'
        end

        unlinked_binary
      end
    end

    ##
    # Deploys the contract and waits for the creation transaction to be mined.
    #
    # This method can be given a source account or client. If an account is given, the it will be
    # used to send the creation transaction. If instead a client is given, the client
    # `default_account` will be used to send the transaction. If no account nor client is given,
    # then the default_account from the default client will be used (if configured).
    #
    # Contract constructor arguments are passed before any options.
    #
    # For example, if you need to deploy a contract with a constructor that takes a string 
    # argument and need to specify a gas limit, you should call: 
    #
    # `MyContract.deploy('string_param', gas: 200_000)`
    #
    # @param as (Object) The source account
    # @param client (Object) The source client (no effect if :as is given)
    # @param timeout (Integer) The transaction mining timeout in seconds, defaults to 120 seconds.
    #
    # This method also takes any parameters the underlying account.send_transaction accepts, like
    # :gas, :gas_price, etc.
    #
    # @return [Object] instance of the contract class pointing the newly deployed contract address.
    #
    def self.deploy(*_args)
      options = _args.last.is_a?(Hash) ? _args.pop : {}
      as = options[:as] || options[:client].try(:default_account) || Etherlite.default_account

      tx_data = binary
      tx_data += constructor.encode(_args) unless constructor.nil?

      tx = as.send_transaction({ data: tx_data }.merge(options))
      if tx.wait_for_block(timeout: options.fetch(:timeout, 120))
        at tx.contract_address, as: as
      end
    end

    ##
    # Creates a new instance of the contract class that points to a given address.
    #
    # As with `deploy`, this method can be given a source account or a client.
    #
    # @param _address (String) The contract location.
    # @param as (Object) The source account
    # @param client (Object) The source client (no effect if :as is given)
    #
    # @return [Object] instance of the contract class pointing the given address.
    #
    def self.at(_address, client: nil, as: nil)
      _address = Etherlite::Utils.normalize_address_param _address

      if as
        new(as.connection, _address, as)
      else
        client ||= ::Etherlite
        new(client.connection, _address, client.default_account)
      end
    end

    # Connection used by this contract instance.
    attr_reader :connection

    def initialize(_connection, _normalized_address, _default_account)
      @connection = _connection
      @normalized_address = _normalized_address
      @default_account = _default_account
    end

    ##
    # Searches for event logs emitted by this contract
    #
    # @param events (Array) Optional event filter, the event filter is an array containing }
    # one or more contract event classes. Ex: `[MyContract::FooEvent, MyContract::BarEvent]`
    # @param from_block (block) first block to be included in the search, defaults to :earliest
    # @param to_block (block) last block to be included in the search, defaults to :latest
    #
    # @return [Array] List of event logs that match the filter
    #
    def get_logs(events: nil, from_block: :earliest, to_block: :latest)
      params = {
        address: json_encoded_address,
        fromBlock: Etherlite::Utils.encode_block_param(from_block),
        toBlock: Etherlite::Utils.encode_block_param(to_block)
      }

      params[:topics] = [events.map { |e| event_topic e }] unless events.nil?

      event_map = Hash[(events || self.class.events).map { |e| [event_topic(e), e] }]

      logs = @connection.ipc_call(:eth_getLogs, params)
      logs.map do |log|
        event = event_map[log["topics"].first]
        # TODO: support anonymous events!
        event.decode(@connection, log) unless event.nil?
      end
    end

    private

    attr_reader :default_account, :normalized_address

    def event_topic(_event)
      '0x' + Etherlite::Utils.sha3(_event.signature)
    end
  end
end
