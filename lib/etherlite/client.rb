module Etherlite
  class Client
    include Api::Node

    attr_reader :connection

    def initialize
      @connection = Connection.new
    end
  end
end
