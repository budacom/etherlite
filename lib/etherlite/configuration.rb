module Etherlite
  class Configuration
    DEFAULTS = {
      url: 'http://127.0.0.1:8545',
      enable_nonce_cache: false,
      chain_id: nil, # any chain
      logger: nil # set by method
    }

    attr_accessor :url, :chain_id, :logger, :enable_nonce_cache

    def initialize
      assign_attributes DEFAULTS
    end

    def reset
      assign_attributes DEFAULTS
    end

    def assign_attributes(_options)
      _options.each { |k, v| public_send("#{k}=", v) }
      self
    end

    def logger
      @logger || default_logger
    end

    private

    def default_logger
      @default_logger ||= Logger.new(STDOUT)
    end
  end
end
