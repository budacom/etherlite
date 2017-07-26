require 'spec_helper'

describe Etherlite::Transaction do
  let(:connection) { double('Etherlite::Connection') }
  let(:tx_hash) { 'the_hash' }
  let(:transaction) { described_class.new connection, tx_hash }

  let(:receipt) do
    {
      'blockNumber' => '0x01',
      'gasUsed' => '0x00FF',
      'contractAddress' => '0xeb6f323b774186406263d2a2a1ce39b1ba538aad'
    }
  end

  describe "#refresh" do
    it "calls connection 'eth_get_transaction_receipt' and updates tx attributes" do
      expect(connection)
        .to receive(:eth_get_transaction_receipt)
        .with(tx_hash)
        .and_return receipt

      transaction.refresh
      expect(transaction.block_number).to eq 1
      expect(transaction.gas_used).to eq 255
      expect(transaction.contract_address).to eq '0xeb6f323b774186406263d2a2a1ce39b1ba538aad'
    end
  end
end
