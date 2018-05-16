require 'spec_helper'

describe Etherlite::Transaction do
  def self.describe_getter(_name, given:, expect:)
    describe "##{_name}" do
      it "calls connection 'eth_get_transaction_by_hash' and returns the transaction #{_name}" do
        expect(connection)
          .to receive(:eth_get_transaction_by_hash)
          .with(tx_hash)
          .and_return(instance_exec(&given))

        expect(transaction.public_send(_name)).to eq instance_exec(&expect)
      end
    end
  end

  let(:connection) { double('Etherlite::Connection') }
  let(:tx_hash) { 'the_hash' }
  let(:transaction) { described_class.new connection, tx_hash }

  let(:rand_value) { rand(1000000000) }
  let(:rand_hex) { '0x' + rand_value.to_s(16) }

  describe_getter(:value, given: -> { { 'value' => rand_hex } }, expect: -> { rand_value })
  describe_getter(:gas, given: -> { { 'gas' => rand_hex } }, expect: -> { rand_value })
  describe_getter(:gas_price, given: -> { { 'gasPrice' => rand_hex } }, expect: -> { rand_value })

  context "given a receipt is available for tx hash" do
    let(:raw_receipt) do
      {
        'blockNumber' => '0x01',
        'gasUsed' => '0x00FF',
        'contractAddress' => '0xeb6f323b774186406263d2a2a1ce39b1ba538aad'
      }
    end

    before { allow(connection).to receive(:eth_get_transaction_receipt).and_return(raw_receipt) }

    describe "#refresh" do
      it "calls connection 'eth_get_transaction_receipt' and updates tx attributes" do
        expect(connection)
          .to receive(:eth_get_transaction_receipt)
          .with(tx_hash)
          .and_return raw_receipt

        transaction.refresh
        expect(transaction.block_number).to eq 1
        expect(transaction.gas_used).to eq 255
        expect(transaction.contract_address).to eq '0xeb6f323b774186406263d2a2a1ce39b1ba538aad'
      end
    end

    context "after calling refresh" do
      before { transaction.refresh }

      describe "#status" do
        context "when receipt status is an integer" do
          let(:raw_receipt) { { 'status' => 1 } }

          it "returns the status as a number" do
            expect(transaction.status).to eq 1
          end
        end

        context "when receipt status is a hex string" do
          let(:raw_receipt) { { 'status' => '0x1' } }

          it "returns the status as a number" do
            expect(transaction.status).to eq 1
          end
        end

        context "when transaction has been removed" do
          let(:raw_receipt) { nil }

          it "returns nil" do
            expect(transaction.status).to be nil
          end
        end
      end
    end
  end
end
