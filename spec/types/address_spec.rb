require 'spec_helper'

describe Etherlite::Types::Address do
  let(:type) { described_class.new }

  describe '#encode' do
    let(:address) { '0xabc0000000000000000000000000000000000000' }

    it "normalizes and pads the given address to generate a 64 bytes string" do
      expect(type.encode(address))
        .to eq('000000000000000000000000abc0000000000000000000000000000000000000')
    end
  end

  describe '#decode' do
    let(:raw_address) { '000000000000000000000000abc0000000000000000000000000000000000000' }

    it "trims and returns a new Etherlite:Address" do
      expect(type.decode(:con, raw_address)).to be_a Etherlite::Address
      expect(type.decode(:con, raw_address).to_s).to eq '0xabc0000000000000000000000000000000000000'
    end
  end
end
