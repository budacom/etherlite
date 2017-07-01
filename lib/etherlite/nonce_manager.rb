module Etherlite
  class NonceManager
    @@nonce_cache = {}
    @@nonce_mutex = Mutex.new

    def initialize(_connection)
      @connection = _connection
    end

    def last_nonce_for(_address)
      _address = Utils.encode_address_param _address
      last_nonce = @@nonce_cache[_address]
      last_nonce = last_observed_nonce_for(_address) if last_nonce.nil?
      last_nonce
    end

    def with_next_nonce_for(_address)
      _address = Utils.encode_address_param _address

      @@nonce_mutex.synchronize do
        next_nonce = last_nonce_for(_address) + 1

        begin
          result = yield next_nonce
          @@nonce_cache[_address] = next_nonce
          return result
        rescue
          # if yield fails, cant be sure about transaction status so must rely again on observing.
          @@nonce_cache.delete _address
          raise
        end
      end
    end

    private

    def last_observed_nonce_for(_address)
      # TODO: support using tx_pool API to improve this:
      # http://qnimate.com/calculating-nonce-for-raw-transactions-in-geth/
      Etherlite::Utils.hex_to_uint(
        @connection.ipc_call(:eth_getTransactionCount, _address, 'pending')
      ) - 1
    end
  end
end
