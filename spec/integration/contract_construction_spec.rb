require 'spec_helper'

describe 'Test contract interaction', integration: true do
  let(:abi_location) do
    File.expand_path('./spec/test_contract/build/contracts/ConstructorTest.json')
  end

  let(:contract_class) { Etherlite::Abi.load_contract_at abi_location }

  it "properly deploys a contract that receives constructor arguments" do
    uint = rand(100)
    string = "string_#{rand(100)}"

    tx = contract_class.deploy uint, string, client: client, gas: 1000000
    tx.wait_for_block

    contract = contract_class.at tx.contract_address, client: client
    expect(contract.uint_param).to eq uint
    expect(contract.string_param).to eq string
  end
end
