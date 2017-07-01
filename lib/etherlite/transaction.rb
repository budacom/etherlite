module Etherlite
  class Transaction
    attr_reader :tx_hash

    def initialize(_connection, _tx_hash)
      @connection = _connection
      @tx_hash = _tx_hash
    end
  end
end
