module Etherlite
  class Connection
    def ipc_call(_method, *_params)
      id = new_unique_id
      payload = { jsonrpc: "2.0", method: _method, params: _params, id: id }

      Net::HTTP.start(server_uri.hostname, server_uri.port) do |http|
        return handle_response http.post(
          server_uri.path || '/',
          payload.to_json,
          "Content-Type" => "application/json"
        ), id
      end
    end

    private

    def server_uri
      URI('http://localhost:8545/')
    end

    def new_unique_id
      (Time.now.to_f * 1000.0).to_i
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
