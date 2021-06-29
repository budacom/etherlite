require 'etherlite/commands/contract/event_base/decode_log_inputs'

module Etherlite::Contract
  class EventBase
    def self.inputs
      nil # To be implemented by sub classes
    end

    def self.original_name
      nil # To be implemented by sub classes
    end

    def self.signature
      @signature ||= begin
        input_sig = inputs.map { |i| i.type.signature }
        "#{original_name}(#{input_sig.join(',')})"
      end
    end

    def self.topic
      '0x' + Etherlite::Utils.sha3(signature)
    end

    def self.decode(_connection, _json)
      new(
        _json['blockHash'],
        _json['blockNumber'].nil? ? nil : Etherlite::Utils.hex_to_uint(_json['blockNumber']),
        _json['transactionHash'],
        Etherlite::Address.new(_connection, Etherlite::Utils.normalize_address(_json['address'])),
        DecodeLogInputs.for(connection: _connection, inputs: inputs, json: _json)
      )
    end

    attr_reader :block_hash, :block_number, :tx_hash, :address, :attributes

    def initialize(_block_hash, _block_number, _tx_hash, _address, _attributes)
      @block_hash = _block_hash
      @block_number = _block_number
      @tx_hash = _tx_hash
      @address = _address
      @attributes = _attributes
    end
  end
end
