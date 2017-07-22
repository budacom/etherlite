module Etherlite
  class Error < StandardError; end

  class RPCError < Error
    attr_reader :http_status, :http_body

    def initialize(_status, _body)
      super("Request returned status code #{_status}")
      @http_status = _status
      @http_body = _body
    end
  end

  class NodeError < Error
    attr_reader :rpc_error_code, :rpc_error_message

    def initialize(_error)
      super("#{_error['code']}: #{_error['message']}")
      @rpc_error_code =  _error['code']
      @rpc_error_message = _error['message']
    end
  end
end
