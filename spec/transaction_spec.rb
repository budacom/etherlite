require 'spec_helper'

describe Etherlite::Transaction do
  let(:conn) { instance_double('Etherlite::Connection') }
  let(:transaction) { described_class.new conn, 'the_hash' }

  let(:raw_tx) do
    {
      'blockNumber' => '0xFFAA',
      'gas' => '0x10',
      'gasPrice' => '0x20',
      'value' => '0x30'
    }
  end

  let(:raw_receipt) do
    {
      'status' => '0x1',
      'gasUsed' => '0x40',
      'logs' => [],
      'contractAddress' => 'an_address'
    }
  end

  let(:block_number) { 65452 }

  before do
    allow(conn).to receive(:eth_get_transaction_by_hash).with('the_hash').and_return raw_tx
    allow(conn).to receive(:eth_get_transaction_receipt).with('the_hash').and_return raw_receipt
    allow(conn).to receive(:eth_block_number).and_return block_number
  end

  describe "#removed?"  do
    it "returns false" do
      expect(transaction.removed?).to be false
    end
  end

  describe "#mined?"  do
    it "returns true" do
      expect(transaction.mined?).to be true
    end
  end

  describe "#gas"  do
    it "returns gas as integer" do
      expect(transaction.gas).to eq 16
    end
  end

  describe "#gas_price"  do
    it "returns gas_price as integer" do
      expect(transaction.gas_price).to eq 32
    end
  end

  describe "#value" do
    it "returns value as integer" do
      expect(transaction.value).to eq 48
    end
  end
  
  describe "#block_number" do
    it "returns block_number as integer" do
      expect(transaction.block_number).to eq 65450
    end
  end

  describe "#confirmations" do
    it "returns the number of confirmations (considering current block)" do
      expect(transaction.confirmations).to eq 3
    end
  end

  describe "#status" do
    it "returns status as integer" do
      expect(transaction.status).to eq 1
    end

    context "when receipt status is an integer" do
      let(:raw_receipt) do
        {
          'status' => 1
        }
      end

      it "returns status as integer" do
        expect(transaction.status).to eq 1
      end
    end
  end

  describe "#gas_used" do
    it "returns gas_used as integer" do
      expect(transaction.gas_used).to eq 64
    end
  end

  describe "#logs" do
    it "returns raw logs" do
      expect(transaction.logs).to eq []
    end
  end

  describe "#contract_address" do
    it "returns the contract address" do
      expect(transaction.contract_address).to eq 'an_address'
    end
  end

  context "when transaction is pending" do
    let(:raw_tx) do
      {
        'gas' => '0x10',
        'gasPrice' => '0x20',
        'value' => '0x30'
      }
    end

    let(:raw_receipt) { nil }

    describe "#removed?"  do
      it "returns false" do
        expect(transaction.removed?).to be false
      end
    end

    describe "#mined?"  do
      it "returns false" do
        expect(transaction.mined?).to be false
      end
    end

    describe "#confirmations" do
      it "returns 0" do
        expect(transaction.confirmations).to eq 0
      end
    end

    describe "#status" do
      it "returns nil" do
        expect(transaction.status).to be nil
      end
    end

    describe "#gas_used" do
      it "returns nil" do
        expect(transaction.gas_used).to be nil
      end
    end

    describe "#logs" do
      it "returns nil" do
        expect(transaction.logs).to be nil
      end
    end

    describe "#contract_address" do
      it "returns nil" do
        expect(transaction.contract_address).to be nil
      end
    end

    describe "#refresh" do
      it "updates the transaction information" do
        transaction.refresh

        expect do 
          raw_tx['blockNumber'] = '0x01'
          transaction.refresh
        end.to change { transaction.mined? }.to true
      end
    end
  end

  context "when transaction has been removed" do
    let(:raw_tx) { nil }
    let(:raw_receipt) { nil }

    describe "#removed?"  do
      it "returns true" do
        expect(transaction.removed?).to be true
      end
    end

    describe "#mined?"  do
      it "returns false" do
        expect(transaction.mined?).to be false
      end
    end
  end
end
