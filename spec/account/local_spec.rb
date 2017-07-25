require 'spec_helper'

describe Etherlite::Account::Local do
  let(:connection) { double('Etherlite::Connection') }
  let(:normalized_address) { '4cd677f0f71185775f45e897aec2727914c0ed56' }
  let(:account) { described_class.new connection, normalized_address }

  describe "#send_transaction" do
    let(:target_address) { '0x5e575279bf9f4acf0a130c186861454247394c06' }
    let(:amount) { 20_000_000 }
    let(:gas_limit) { 21_000 }
    let(:gas_price) { 10_000 }
    let(:data) { '0xda7a' }
    let(:passphrase) { 'muchsecret' }

    it "calls 'personal_send_transaction' if given a passphrase" do
      expect(connection).to receive(:personal_send_transaction).with(
        {
          from: '0x' + normalized_address,
          to: target_address,
          value: '0x' + amount.to_s(16),
          data: data,
          gas: '0x' + gas_limit.to_s(16),
          gasPrice: '0x' + gas_price.to_s(16)
        },
        passphrase
      ).and_return 'a_hash'

      tx = account.send_transaction(
        to: target_address,
        value: amount,
        gas: gas_limit,
        gas_price: gas_price,
        data: data,
        passphrase: passphrase
      )

      expect(tx).to be_a Etherlite::Transaction
      expect(tx.tx_hash).to eq 'a_hash'
    end

    it "calls 'eth_send_transaction' if no passphrase is given" do
      expect(connection).to receive(:eth_send_transaction).with(
        from: '0x' + normalized_address,
        to: target_address,
        value: '0x' + amount.to_s(16),
        data: data,
        gas: '0x' + gas_limit.to_s(16),
        gasPrice: '0x' + gas_price.to_s(16)
      ).and_return 'a_hash'

      tx = account.send_transaction(
        to: target_address,
        value: amount,
        gas: gas_limit,
        gas_price: gas_price,
        data: data
      )

      expect(tx).to be_a Etherlite::Transaction
      expect(tx.tx_hash).to eq 'a_hash'
    end
  end
end
