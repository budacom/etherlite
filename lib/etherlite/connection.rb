module Etherlite
  class Connection
    def initialize(_uri)
      @uri = _uri
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
        # puts _response.body
        json_body = JSON.parse _response.body
        # TODO: check id
        json_body['result']
      else
        raise _response
      end
    end
  end
end
