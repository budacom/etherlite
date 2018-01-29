module Etherlite::Contract
  class Base
    include Etherlite::Api::Address

    def self.functions
      @functions ||= []
    end

    def self.events
      @events ||= []
    end

    def self.unlinked_binary
      '0x0'
    end

    def self.constructor
      nil
    end

    def self.binary
      @binary ||= begin
        if /__[^_]+_+/ === unlinked_binary
          raise UnlinkedContractError, 'compiled contract contains unresolved library references'
        end

        unlinked_binary
      end
    end

    def self.deploy(*_args)
      options = _args.last.is_a?(Hash) ? _args.pop : {}
      as = options[:as] || options[:client].try(:default_account) || Etherlite.default_account

      tx_data = binary
      tx_data += constructor.encode(_args) unless constructor.nil?

      as.send_transaction({ data: tx_data }.merge(options))
    end

    def self.at(_address, client: nil, as: nil)
      _address = Etherlite::Utils.normalize_address_param _address

      if as
        new(as.connection, _address, as)
      else
        client ||= ::Etherlite
        new(client.connection, _address, client.default_account)
      end
    end

    attr_reader :connection

    def initialize(_connection, _normalized_address, _default_account)
      @connection = _connection
      @normalized_address = _normalized_address
      @default_account = _default_account
    end

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
