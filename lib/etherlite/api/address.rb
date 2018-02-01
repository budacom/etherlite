module Etherlite
  module Api
    module Address
      def address
        '0x' + normalized_address
      end

      def get_balance(block: :latest)
        connection.eth_get_balance(
          json_encoded_address, Etherlite::Utils.encode_block_param(block)
        )
      end

      private

      def json_encoded_address
        '0x' + normalized_address
      end
    end
  end
end
