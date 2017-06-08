module Etherlite::Contract
  class Base
    include Etherlite::Api::Address

    def self.functions
      @functions ||= []
    end

    def self.events
      @events ||= []
    end

    def self.at(_address, client: nil, as: nil)
      client ||= ::Etherlite # use default client if no client is provided

      new(
        client.connection,
        Etherlite::Utils.normalize_address_param(_address),
        as || client.first_account
      )
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
