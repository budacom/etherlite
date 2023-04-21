module Etherlite
  class Connection
    include Api::Rpc
    include Api::ParityRpc

    attr_reader :uri, :chain_id, :use_parity

    def initialize(_uri, _options = {})
      @uri = _uri
      @chain_id = _options[:chain_id]
      @use_parity = _options[:use_parity]
    end

    def ipc_call(_method, *_params)
      id = new_unique_id
      payload = { jsonrpc: "2.0", method: _method, params: _params, id: id }

      # TODO: support ipc
      Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: use_ssl?) do |http|
        return handle_response http.post(
          @uri.path.empty? ? '/' : @uri.path,
          payload.to_json,
          "Content-Type" => "application/json"
        ), id
      end
    end

    private

    def new_unique_id
      (Time.now.to_f * 1000.0).to_i
    end

    def use_ssl?
      @uri.scheme == 'https'
    end

    def handle_response(_response, _id)
      case _response
      when Net::HTTPSuccess
        json_body = JSON.parse _response.body
        raise NodeError.new json_body['error'] if json_body['error']
        json_body['result']
      else
        raise RPCError.new _response.code, _response.body
      end
    end
  end
end
