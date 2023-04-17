require 'spec_helper'

describe 'Test contract interaction', integration: true do
  let(:abi_location) { File.expand_path('./spec/test_contract/build/contracts/TestContract.json') }
  let(:contract_class) { Etherlite::Abi.load_contract_at abi_location }

  context "when contract has been deployed" do
    let!(:contract) do
      tx = contract_class.deploy client: client, gas: 1000000
      tx.wait_for_block
      contract_class.at tx.contract_address, client: client
    end

    it "is assigned an address" do
      expect(contract.address).not_to be nil
    end

    it "properly handles the `testUint` example" do
      expect(contract.test_uint(726261)).to eq 726261
      expect(contract.test_uint(1)).to eq 1
      expect(contract.test_uint(0)).to eq 0
    end

    it "properly handles the `testInt` example" do
      expect(contract.test_int(726261)).to eq 726261
      expect(contract.test_int(1)).to eq 1
      expect(contract.test_int(0)).to eq 0
      expect(contract.test_int(-1)).to eq(-1)
      expect(contract.test_int(-726261)).to eq(-726261)
    end

    it "properly handles the `testIntFixedArray` example" do
      expect(contract.test_int_fixed_array([1, 2, 3])).to eq [1, 2, 3]
    end

    it "properly handles the `testIntDynArray` example" do
      expect(contract.test_int_dyn_array([1, 2, 3])).to eq [1, 2, 3]
      expect(contract.test_int_dyn_array([2])).to eq [2]
    end

    it "properly handles the `testEvent` example" do
      tx = nil
      expect { tx = contract.test_event(-10, 30, 'foo') }
        .to change { contract.get_logs.count }.by(1)

      last_log = contract.get_logs.last
      expect(last_log).to be_a contract_class::TestEvent
      expect(last_log.tx_hash).to eq tx.tx_hash
      expect(last_log.address.to_s).to eq contract.address
      expect(last_log.int_param).to eq -10
      expect(last_log.uint_param).to eq 30
      expect(last_log.string_param).to eq 'foo'
      expect(last_log.address_param.to_s).to eq client.default_account.address
    end

    it "properly handles the `testEvent` second example (contract returned transaction)" do
      tx = contract.test_event(-10, 30, 'foo')
      tx.refresh

      expect(tx.events.length).to eq 1
      expect(tx.events.first).to be_a contract_class::TestEvent
      expect(tx.events.first.int_param).to eq -10
    end

    it "properly handles the `testEvents` example" do
      expect { contract.test_events }.to change { contract.get_logs.count }.by(2)

      expect(contract.get_logs(events: [contract_class::TestEvent1]).count).to eq 1
      expect(contract.get_logs(events: [contract_class::TestEvent2]).count).to eq 1
    end
  end
end
