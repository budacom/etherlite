require 'spec_helper'

describe 'Test contract interaction' do
  let(:abi_location) { File.expand_path('./spec/test_contract/build/contracts/TestContract.json') }
  let(:contract_class) { Etherlite::Abi.load_contract_at abi_location }
  let(:client) { Etherlite.connect 'http://localhost:8001' }

  around(:each) do |example|
    WebMock.allow_net_connect!
    snapshot_id = client.connection.evm_snapshot
    begin
      example.run
    ensure
      client.connection.evm_revert snapshot_id
      WebMock.disable_net_connect!
    end
  end

  context "when contract has been deployed" do
    let!(:contract) { contract_class.deploy client: client, gas: 1000000 }

    it "is assigned an address" do
      expect(contract.address).not_to be nil
    end

    it "properly handles then `testUint` example" do
      expect(contract.test_uint(726261)).to eq 726261
      expect(contract.test_uint(1)).to eq 1
      expect(contract.test_uint(0)).to eq 0
    end

    it "properly handles then `testInt` example" do
      expect(contract.test_int(726261)).to eq 726261
      expect(contract.test_int(1)).to eq 1
      expect(contract.test_int(0)).to eq 0
      expect(contract.test_int(-1)).to eq -1
      expect(contract.test_int(-726261)).to eq -726261
    end

    it "properly handles then `testIntFixedArray` example" do
      expect(contract.test_int_fixed_array([1, 2, 3])).to eq [1, 2, 3]
    end

    it "properly handles then `testIntDynArray` example" do
      expect(contract.test_int_dyn_array([1, 2, 3])).to eq [1, 2, 3]
      expect(contract.test_int_dyn_array([2])).to eq [2]
    end
  end
end
