module Etherlite
  class Address
    include Etherlite::Api::Address

    attr_reader :connection, :normalized_address

    def initialize(_connection, _normalized_address)
      @connection = _connection
      @normalized_address = _normalized_address
    end

    def to_s
      # TODO: format address using case-chechsum
      address
    end
  end
end
