module Etherlite
  module Api
    module ParityRpc
      def parity_next_nonce(_address)
        Etherlite::Utils.hex_to_uint ipc_call(:parity_nextNonce, _address)
      end
    end
  end
end
