module Etherlite::Railties
  module ConfigurationExtensions
    def self.included(_klass)
      _klass::DEFAULTS[:contracts_path] = 'contracts'
    end

    attr_accessor :contracts_path
  end
end
