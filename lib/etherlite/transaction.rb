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
      mined?
    end

    def mined?
      @receipt.key? 'blockNumber'
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
      while !refresh
        return false if Time.now - start > timeout
        sleep 1
      end

      true
    end
  end
end
