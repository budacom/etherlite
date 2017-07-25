require 'spec_helper'

describe Etherlite::Account::Base do
  let(:connection) { double('Etherlite::Connection') }
  let(:normalized_address) { '4cd677f0f71185775f45e897aec2727914c0ed56' }
  let(:account) { described_class.new connection, normalized_address }

  describe "#transfer_to" do
    let(:target_address) { '0x5e575279bf9f4acf0a130c186861454247394c06' }
    let(:amount) { 20_000_000 }

    it "calls 'send_transaction' with proper parameters" do
      expect(account).to receive(:send_transaction).with(
        hash_including(
          to: target_address,
          value: amount,
          foo: :bar
        )
      ).and_return 'a_transaction'

      tx = account.transfer_to(target_address, amount: amount, foo: :bar)
      expect(tx).to eq 'a_transaction'
    end
  end

  describe "#call" do
    let(:target_address) { '0x5e575279bf9f4acf0a130c186861454247394c06' }
    let(:amount) { 20_000_000 }
    let(:gas_limit) { 100_000 }
    let(:function) { double('Etherlite::Contract::Function') }

    context "when function is constant" do
      before do
        allow(function).to receive(:constant?).and_return true
      end

      it "calls connection's 'eth_call' with proper data and returns the decoded result" do
        expect(function).to receive(:encode).with(['param1', 'param2']).and_return :encoded_fun
        expect(function).to receive(:decode).with(connection, :result).and_return :decoded_result

        expect(connection).to receive(:eth_call).with(
          {
            from: ('0x' + normalized_address),
            to: target_address,
            data: :encoded_fun
          },
          'pending'
        ).and_return :result

        result = account.call(target_address, function, 'param1', 'param2', block: 'pending')
        expect(result).to eq :decoded_result
      end
    end

    context "when function is not constant and payable" do
      before do
        allow(function).to receive(:constant?).and_return false
        allow(function).to receive(:payable?).and_return true
      end

      it "calls 'send_transaction' with function data and returns a Transaction" do
        expect(function).to receive(:encode).with(['param1']).and_return '0xda7a'

        expect(account).to receive(:send_transaction).with(
          hash_including(
            to: target_address,
            value: amount,
            data: '0xda7a',
            gas: gas_limit
          )
        ).and_return 'a_transaction'

        tx = account.call(target_address, function, 'param1', pay: amount, gas: gas_limit)
        expect(tx).to eq 'a_transaction'
      end
    end
  end
end
