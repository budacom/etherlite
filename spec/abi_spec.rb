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
            'outputs' => [],
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
        ]
      )
    end

    it "generates a new contract class" do
      expect(contract).to be < Etherlite::Contract::Base
    end

    it "properly loads the contract's functions" do
      expect(contract.functions.count).to eq 2

      expect(contract.functions.first.constant?).to be false
      expect(contract.functions.first.args.count).to eq 1

      expect(contract.functions.last.constant?).to be true
      expect(contract.functions.last.args.count).to eq 2
    end

    it "properly loads the contract's events" do
      expect(contract.events.count).to eq 1

      expect(contract.events.first.inputs.count).to eq 2
      expect(contract.events.first.inputs.first.indexed?).to be true
      expect(contract.events.first.inputs.last.indexed?).to be false

      expect(contract::Deposit).to be < Etherlite::Contract::EventBase
    end

    context "given an instance of the contract with a default account" do
      let(:address) { 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
      let(:account) { Etherlite::Account.new(nil, nil) }
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

    it "properly parses name and arguments" do
      function = abi.load_function('void baz(uint32,bool)')
      expect(function.name).to eq 'baz'
      expect(function.args.count).to eq 2
      expect(function.args[0]).to be_a(Etherlite::Types::Integer)
      expect(function.args[1]).to be_a(Etherlite::Types::Bool)
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
