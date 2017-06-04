module Etherlite
  class Address
    include Etherlite::Api::Address

    attr_reader :connection, :address

    def initialize(_connection, _normalized_address)
      @connection = _connection
      @address = _normalized_address
    end

    def to_s
      # TODO: format address using case-chechsum
      address
    end

    private

    attr_reader :normalized_address
  end
end
