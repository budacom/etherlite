module Etherlite
  class Transaction
    attr_reader :tx_hash

    def initialize(_connection, _tx_hash)
      @connection = _connection
      @tx_hash = _tx_hash
      @loaded = false
    end

    def refresh
      @original = @connection.eth_get_transaction_by_hash(@tx_hash)
      @loaded = true
      self
    end

    def original
      refresh unless @loaded
      @original
    end

    def removed?
      original.nil?
    end

    def mined?
      original.present? && !original['blockNumber'].nil?
    end

    def gas
      original && Utils.hex_to_uint(original['gas'])
    end

    def gas_price
      original && Utils.hex_to_uint(original['gasPrice'])
    end

    def value
      original && Utils.hex_to_uint(original['value'])
    end

    def block_number
      return nil unless mined?

      Utils.hex_to_uint(original['blockNumber'])
    end

    def block_hash
      return nil unless mined?

      original['blockHash']
    end

    def confirmations
      return 0 unless mined?

      (@connection.eth_block_number - block_number) + 1
    end

    # receipt attributes

    def receipt
      return nil unless mined?
      
      @receipt ||= @connection.eth_get_transaction_receipt(@tx_hash)
    end

    def status
      return nil if receipt.nil?

      receipt['status'].is_a?(String) ? Utils.hex_to_uint(receipt['status']) : receipt['status']
    end

    def succeeded?
      status == 1
    end

    def failed?
      status == 0
    end

    def gas_used
      receipt && Utils.hex_to_uint(receipt['gasUsed'])
    end

    def logs
      receipt && (receipt['logs'] || [])
    end

    def events
      receipt && ::Etherlite::EventProvider.parse_raw_logs(@connection, logs)
    end

    def contract_address
      receipt && receipt['contractAddress']
    end

    def wait_for_block(timeout: 120)
      start = Time.now
      while !refresh.mined?
        return false if removed?
        return false if Time.now - start > timeout
        sleep 1
      end

      true
    end
  end
end
