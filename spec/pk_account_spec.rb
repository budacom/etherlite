require 'spec_helper'

describe Etherlite::PkAccount do
  let(:connection) { double('Etherlite::Connection') }
  let(:pk) { '409b803827d8a02c987e6b18a668b6333ff97f24f8075938b63d0ed737fcccb1' }
  let(:pk_address) { '4cd677f0f71185775f45e897aec2727914c0ed56' }
  let(:account) { described_class.new connection, pk }
  let(:gas_price) { 10_000 }
  let(:tx_count) { 20 }

  before do
    Etherlite::NonceManager.clear_cache

    allow(connection).to receive(:chain_id).and_return 1
    allow(connection).to receive(:eth_gas_price).and_return gas_price
    allow(connection).to receive(:eth_get_transaction_count)
      .with('0x' + pk_address, 'pending').and_return tx_count
  end

  describe "#normalized_address" do
    it "returns the address corresponding to the given PK" do
      expect(account.normalized_address).to eq pk_address
    end
  end

  describe "#transfer_to" do
    let(:target_address) { '0x5e575279bf9f4acf0a130c186861454247394c06' }
    let(:amount) { 20_000_000 }
    let(:gas_limit) { 21_000 }

    it "calls 'eth_send_raw_transaction' and returns a Transaction" do
      expect(connection).to receive(:eth_send_raw_transaction) do |raw|
        tx = Eth::Tx.decode raw
        expect(tx.value).to eq amount
        expect(tx.gas_limit).to eq gas_limit
        expect(tx.gas_price).to eq gas_price
        expect(binary_to_hex(tx.to)).to eq target_address
        expect(tx.nonce).to eq tx_count

        'a_hash'
      end

      tx = account.transfer_to(target_address, amount: amount, gas: gas_limit)
      expect(tx).to be_a Etherlite::Transaction
      expect(tx.tx_hash).to eq 'a_hash'
    end
  end

  describe "#call" do
    let(:target_address) { '0x5e575279bf9f4acf0a130c186861454247394c06' }
    let(:amount) { 20_000_000 }
    let(:gas_limit) { 100_000 }

    context "when function is not constant and payable" do
      let(:function) { double('Etherlite::Contract::Function') }

      before do
        allow(function).to receive(:constant?).and_return false
        allow(function).to receive(:payable?).and_return true
      end

      it "calls 'eth_send_raw_transaction' with function data and returns a Transaction" do
        expect(function).to receive(:encode).with(['param1']).and_return '0xda7a'

        expect(connection).to receive(:eth_send_raw_transaction) do |raw|
          tx = Eth::Tx.decode raw
          expect(tx.value).to eq amount
          expect(tx.data).to eq '0xda7a'
          expect(tx.gas_limit).to eq gas_limit
          expect(tx.gas_price).to eq gas_price
          expect(binary_to_hex(tx.to)).to eq target_address
          expect(tx.nonce).to eq tx_count

          'a_hash'
        end

        tx = account.call(target_address, function, 'param1', pay: amount, gas: gas_limit)
        expect(tx).to be_a Etherlite::Transaction
        expect(tx.tx_hash).to eq 'a_hash'
      end
    end

    context "when function is constant" do
      let(:function) { double('Etherlite::Contract::Function') }

      before { allow(function).to receive(:constant?).and_return true }

      it "calls 'eth_call' with proper data and returns the decoded result" do
        expect(function).to receive(:encode).with(['param1', 'param2']).and_return :encoded_fun
        expect(function).to receive(:decode).with(connection, :result).and_return :decoded_result

        expect(connection).to receive(:eth_call)
          .with(
            {
              from: ('0x' + pk_address),
              to: target_address,
              data: :encoded_fun
            },
            'latest'
          ).and_return :result

        result = account.call(target_address, function, 'param1', 'param2')
        expect(result).to eq :decoded_result
      end
    end
  end

  def binary_to_hex(_string)
    '0x' + _string.unpack('H*').first
  end
end
