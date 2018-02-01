module Etherlite
  module Api
    module Rpc
      def eth_block_number
        Etherlite::Utils.hex_to_uint ipc_call(:eth_blockNumber)
      end

      def eth_gas_price
        Etherlite::Utils.hex_to_uint ipc_call(:eth_gasPrice)
      end

      def eth_get_transaction_receipt(_tx_hash)
        ipc_call(:eth_getTransactionReceipt, _tx_hash)
      end

      def eth_get_transaction_count(_address, _block = 'latest')
        Etherlite::Utils.hex_to_uint ipc_call(:eth_getTransactionCount, _address, _block)
      end

      def eth_get_balance(_address, _block = 'latest')
        Etherlite::Utils.hex_to_uint ipc_call(:eth_getBalance, _address, _block)
      end

      def eth_call(_params, _block = 'latest')
        ipc_call(:eth_call, _params, _block)
      end

      def eth_send_raw_transaction(_hex_data)
        ipc_call(:eth_sendRawTransaction, _hex_data)
      end

      def eth_send_transaction(_params)
        ipc_call(:eth_sendTransaction, _params)
      end

      def personal_send_transaction(_params, _passphrase)
        ipc_call(:personal_sendTransaction, _params, _passphrase)
      end

      # TestRPC support

      def evm_snapshot
        ipc_call(:evm_snapshot)
      end

      def evm_revert(_snapshot_id)
        ipc_call(:evm_revert, _snapshot_id)
      end

      def evm_increase_time(_seconds)
        Etherlite::Utils.hex_to_uint ipc_call(:evm_increase_time, _seconds)
      end

      def evm_mine
        ipc_call(:evm_mine)
      end
    end
  end
end
