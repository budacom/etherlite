module Etherlite
  class Account
    include Etherlite::Api::Address

    attr_reader :connection, :normalized_address

    def initialize(_connection, _normalized_address)
      @connection = _connection
      @normalized_address = _normalized_address
    end

    def unlock(_passphrase)
      @passphrase = _passphrase
    end

    def lock
      @passphrase = nil
    end

    def send_to(_target, _options = {})
      params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        value: Utils.encode_quantity_param(_options[:amount] || 0)
      }

      send_transaction params, _options
    end

    def call(_target, _function, *_params)
      _function = Utils.parse_function(_function) unless _function.is_a? Contract::Function
      options = _params.last.is_a?(Hash) ? _params.pop : {}

      params = {
        from: json_encoded_address,
        to: Utils.encode_address_param(_target),
        data: _function.encode(_params)
      }

      if _function.constant?
        _function.decode @connection, @connection.ipc_call(:eth_call, params, "latest")
      else
        if _function.payable? && options.key?(:pay)
          params[:value] = Utils.encode_quantity_param options[:pay]
        end

        send_transaction params, options
      end
    end

    private

    attr_reader :normalized_address

    def send_transaction(_params, _opt)
      _params[:gas] = Utils.encode_quantity_param(_opt[:gas]) if _opt.key? :gas
      _params[:gasPrice] = Utils.encode_quantity_param(_opt[:gas_price]) if _opt.key? :gas_price

      passphrase = _opt.fetch(:passphrase, @passphrase)
      if passphrase.nil?
        @connection.ipc_call(:eth_sendTransaction, _params)
      else
        @connection.ipc_call(:personal_sendTransaction, _params, passphrase)
      end
    end
  end
end
