module Etherlite
  class NonceManager
    @@nonce_cache = {}
    @@nonce_mutex = Mutex.new

    def self.clear_cache
      @@nonce_cache = {}
    end

    def initialize(_connection)
      @connection = _connection
    end

    def last_nonce_for(_normalized_address)
      last_nonce = @@nonce_cache[_normalized_address]
      last_nonce = last_observed_nonce_for(_normalized_address) if last_nonce.nil?
      last_nonce
    end

    def next_nonce_for(_normalized_address, replace: false, nonce: nil)
      if nonce.nil?
        nonce = last_nonce_for(_normalized_address)
        nonce += 1 if nonce.negative? || !replace # if first tx, don't replace
      end

      nonce
    end

    def with_next_nonce_for(_normalized_address, _options = {})
      @@nonce_mutex.synchronize do
        nonce = next_nonce_for(_normalized_address, **_options)

        begin
          result = yield nonce
          @@nonce_cache[_normalized_address] = nonce if caching_enabled?
          return result
        rescue
          # if yield fails, cant be sure about transaction status so must rely again on observing.
          @@nonce_cache.delete _normalized_address if caching_enabled?
          raise
        end
      end
    end

    private

    def last_observed_nonce_for(_normalized_address)
      if @connection.use_parity
        @connection.parity_next_nonce('0x' + _normalized_address) - 1
      else
        # https://github.com/ethereum/go-ethereum/issues/2736
        @connection.eth_get_transaction_count('0x' + _normalized_address, 'pending') - 1
      end
    end

    def caching_enabled?
      Etherlite.config.enable_nonce_cache
    end
  end
end
