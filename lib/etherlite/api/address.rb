module Etherlite
  module Api
    module Address
      extend Forwardable

      def address
        normalized_address
      end

      def get_balance(block: :latest)
        Etherlite::Utils.hex_to_uint(
          connection.ipc_call(
            :eth_getBalance,
            '0x' + normalized_address,
            Etherlite::Utils.encode_block_param(block)
          )
        )
      end
    end
  end
end
