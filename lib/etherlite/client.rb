module Etherlite
  class Client
    include Api::Node

    attr_reader :connection

    def initialize(_connection)
      @connection = _connection
    end
  end
end
