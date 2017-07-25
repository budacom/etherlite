module Etherlite
  module Account
    class Local < Base
      def unlock(_passphrase)
        @passphrase = _passphrase
      end

      def lock
        @passphrase = nil
      end

      def send_transaction(_options = {})
        params = build_params_from_options _options
        passphrase = _options.fetch(:passphrase, @passphrase)

        Transaction.new @connection, send_transaction_with_passphrase(params, passphrase)
      end

      private

      def build_params_from_options(_opt)
        { from: json_encoded_address }.tap do |pr|
          pr[:to] = Utils.encode_address_param(_opt[:to]) if _opt.key? :to
          pr[:value] = Utils.encode_quantity_param(_opt[:value]) if _opt.key? :value
          pr[:data] = _opt[:data] if _opt.key? :data
          pr[:gas] = Utils.encode_quantity_param(_opt[:gas]) if _opt.key? :gas
          pr[:gasPrice] = Utils.encode_quantity_param(_opt[:gas_price]) if _opt.key? :gas_price
        end
      end

      def send_transaction_with_passphrase(_params, _passphrase)
        if _passphrase.nil?
          @connection.eth_send_transaction _params
        else
          @connection.personal_send_transaction _params, _passphrase
        end
      end
    end
  end
end
