require 'spec_helper'

describe Etherlite::Abi do
  let(:abi) { described_class }

  describe '.load_contract' do
    let(:contract) do
      abi.load_contract(
        'contract_name' => "Wallet",
        'abi' => [
          {
            'constant' => false,
            'inputs' => [
              { 'name' => "integer", 'type' => "uint256" }
            ],
            'name' => "fooBar",
            'outputs' => [
              { 'name' => "string", 'type' => "string" }
            ],
            'payable' => false,
            'type' => "function"
          },
          {
            'constant' => true,
            'inputs' => [
              { 'name' => "someAddress", 'type' => "address" },
              { 'name' => "someBool", 'type' => "bool" }
            ],
            'name' => "baz",
            'outputs' => [],
            'payable' => false,
            'type' => "function"
          },
          {
            'anonymous' => false,
            'inputs' => [
              { 'indexed' => true, 'name' => "id", 'type' => "uint256" },
              { 'indexed' => false, 'name' => "value", 'type' => "uint256" }
            ],
            'name' => "Deposit",
            'type' => "event"
          }
        ],
        'unlinked_binary' => '0xd474'
      )
    end

    it "generates a new contract class" do
      expect(contract).to be < Etherlite::Contract::Base
    end

    it "loads the contract's functions" do
      expect(contract.functions.count).to eq 2

      expect(contract.functions.first.constant?).to be false
      expect(contract.functions.first.inputs.count).to eq 1
      expect(contract.functions.first.inputs[0]).to be_a Etherlite::Types::Integer
      expect(contract.functions.first.outputs.count).to eq 1
      expect(contract.functions.first.outputs[0]).to be_a Etherlite::Types::String

      expect(contract.functions.last.constant?).to be true
      expect(contract.functions.last.inputs.count).to eq 2
      expect(contract.functions.last.outputs.count).to eq 0
    end

    it "loads the contract's events" do
      expect(contract.events.count).to eq 1

      expect(contract.events.first.inputs.count).to eq 2
      expect(contract.events.first.inputs.first.indexed?).to be true
      expect(contract.events.first.inputs.last.indexed?).to be false

      expect(contract::Deposit).to be < Etherlite::Contract::EventBase
    end

    it "adds a 'unlinked_binary' class method to the contract" do
      expect(contract.unlinked_binary).to eq '0xd474'
    end

    context "given an instance of the contract with a default account" do
      let(:address) { '0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
      let(:account) { Etherlite::Account::Local.new(nil, nil) }
      let(:instance) { contract.at address, as: account }

      it "provides contract methods for each function" do
        expect(account).to receive(:call).with(address, contract.functions.first, :foo, :bar)

        instance.foo_bar(:foo, :bar)
      end
    end
  end

  describe '.load_function' do
    it "properly validates signature attribute types" do
      expect { abi.load_function('void baz(uint32)') }.not_to raise_error
      expect { abi.load_function('void baz(uint)') }.not_to raise_error
      expect { abi.load_function('void baz(fixed32x32)') }.not_to raise_error
      expect { abi.load_function('void baz(bytes)') }.not_to raise_error
      expect { abi.load_function('void baz(bytes17)') }.not_to raise_error
      expect { abi.load_function('void baz(string)') }.not_to raise_error
      expect { abi.load_function('void baz(string32)') }.to raise_error ArgumentError
      expect { abi.load_function('void baz(uint17)') }.to raise_error ArgumentError
      expect { abi.load_function('void baz(uint512)') }.to raise_error ArgumentError
      expect { abi.load_function('void baz(bytes0)') }.to raise_error ArgumentError
      expect { abi.load_function('void baz(bytes33)') }.to raise_error ArgumentError
    end

    it "properly parses name and inputs" do
      function = abi.load_function('void baz(uint32,bool)')
      expect(function.name).to eq 'baz'
      expect(function.inputs.count).to eq 2
      expect(function.inputs[0]).to be_a Etherlite::Types::Integer
      expect(function.inputs[1]).to be_a Etherlite::Types::Boolean
    end

    it "properly parses outputs" do
      function = abi.load_function('uint baz()')
      expect(function.outputs.count).to eq 1
      expect(function.outputs[0]).to be_a Etherlite::Types::Integer
    end

    it "properly sets the constant attribute" do
      expect(abi.load_function('void baz(uint32,bool)').constant?).to be true
      expect(abi.load_function('payable baz(uint32,bool)').constant?).to be false
    end

    it "properly sets the payable attribute" do
      expect(abi.load_function('payable baz(uint32,bool)').payable?).to be true
      expect(abi.load_function('onchain baz(uint32,bool)').payable?).to be false
      expect(abi.load_function('uint baz(uint32,bool)').payable?).to be false
    end
  end
end
