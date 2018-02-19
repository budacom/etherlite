module Etherlite
  class Transaction
    attr_reader :tx_hash, :receipt

    def initialize(_connection, _tx_hash)
      @connection = _connection
      @tx_hash = _tx_hash
      @receipt = {}
    end

    def refresh
      @receipt = @connection.eth_get_transaction_receipt(@tx_hash) || {}
      self
    end

    def removed?
      @receipt.nil?
    end

    def succeeded?
      status == 1
    end

    def status
      return nil if removed?
      status = @receipt['status']
      status.is_a?(String) ? Utils.hex_to_uint(status) : status
    end

    def mined?
      !removed? && @receipt.key?('blockNumber')
    end

    def confirmations
      return 0 unless mined?

      @connection.eth_block_number - block_number
    end

    def gas_used
      Utils.hex_to_uint @receipt['gasUsed']
    end

    def block_number
      Utils.hex_to_uint @receipt['blockNumber']
    end

    def contract_address
      @receipt['contractAddress']
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
