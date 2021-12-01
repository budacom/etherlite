module Etherlite::Utils
  class ValidateAddress < PowerTypes::Command.new(:address)
    MATCHER = /^0x[0-9a-fA-F]{40}$/

    def perform
      return false unless MATCHER === @address
      return false if /[A-F]/ === @address && !valid_checksum?
      true
    end

    private

    def valid_checksum?
      trimmed_address = @address.gsub(/^0x/, '')
      address_hash = Etherlite::Utils.keccak trimmed_address.downcase

      trimmed_address.chars.each_with_index do |c, i|
        hash_byte = address_hash[i].to_i(16)
        return false if (hash_byte > 7 && c.upcase != c) || (hash_byte <= 7 && c.downcase != c)
      end

      true
    end
  end
end
