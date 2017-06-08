module Etherlite
  module Api
    module Address
      def address
        '0x' + normalized_address
      end

      def get_balance(block: :latest)
        Etherlite::Utils.hex_to_uint(
          connection.ipc_call(
            :eth_getBalance,
            json_encoded_address,
            Etherlite::Utils.encode_block_param(block)
          )
        )
      end

      private

      def json_encoded_address
        '0x' + normalized_address
      end
    end
  end
end
