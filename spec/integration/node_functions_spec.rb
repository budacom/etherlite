require 'spec_helper'

describe 'Test node functions against testrpc', integration: true do
  # client is loaded by the spec_helper

  describe "#accounts" do
    it "returns accounts managed by the node" do
      expect(client.accounts.length).to be > 0
      expect(client.accounts.first).to be_a Etherlite::Account::Local
    end
  end

  describe "#default_account" do
    it "returns the first account managed by the node" do
      expect(client.accounts.first).to eq client.default_account
    end
  end

  context "given a transaction" do
    let(:pk) { '5265130d78f73a53aeac4ffc0fa03f42a3d3526fee8f9af31be0807b11c5233a' }
    let(:pk_address) { '0xe8C1b5A6ac249b8f01AA042B5819607bbf06C557' }
    let!(:hash) { client.transfer_to(pk_address, amount: 1e18.to_i).tx_hash }

    describe "#load_address" do
      it "returns an address object that can be queried for balance" do
        expect(client.load_address(pk_address).get_balance).to eq 1e18.to_i
      end

      it "fails if address has the wrong format" do
        expect { client.load_address('64e1c9bf6519350d1c46b0cc79b8675bd9fd5fef') }
          .to raise_error(ArgumentError)
      end
    end

    describe "#load_account" do
      let(:other_address) { '0x64e1c9bf6519350d1c46b0cc79b8675bd9fd5fef' }

      it "allows loading and account from its private key" do
        other_address = '0x64e1c9bf6519350d1c46b0cc79b8675bd9fd5fef'
        amount = 1e6.to_i

        account = client.load_account from_pk: pk

        expect { account.transfer_to(other_address, amount: amount) }
          .to change { client.load_address(other_address).get_balance }.by amount
      end
    end

    describe "#load_transaction" do
      it "returns an transaction object that can be queried for transaction status" do
        expect(client.load_transaction(hash).refresh.succeeded?).to be true
        expect(client.load_transaction(hash).refresh.mined?).to be true
      end

      it "returns an transaction object that can be queried for transaction gas usage" do
        expect(client.load_transaction(hash).refresh.gas_used).to eq 21000
      end

      it "returns an transaction object that can be queried for transaction block number" do
        expect(client.load_transaction(hash).refresh.block_number).to eq 1
      end

      it "returns an transaction object that can be queried for transaction confirmations" do
        expect(client.load_transaction(hash).refresh.confirmations).to eq 0
        client.connection.evm_mine
        expect(client.load_transaction(hash).refresh.confirmations).to eq 1
      end
    end
  end
end
