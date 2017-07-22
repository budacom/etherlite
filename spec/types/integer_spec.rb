require 'spec_helper'

describe Etherlite::Types::Integer do
  let(:size) { 256 }
  let(:type) { described_class.new signed, size }

  context "when signed" do
    let(:signed) { true }

    describe '#encode' do
      it "propery handles signed and unsigned values" do
        expect(type.encode(1))
          .to eq('0000000000000000000000000000000000000000000000000000000000000001')

        expect(type.encode(-1))
          .to eq('ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff')
      end
    end

    describe '#decode' do
      it "propery handles raw values" do
        expect(type.decode(:c, '0000000000000000000000000000000000000000000000000000000000000001'))
          .to eq(1)

        expect(type.decode(:c, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'))
          .to eq(-1)
      end
    end
  end

  context "when unsigned" do
    let(:signed) { false }

    describe '#encode' do
      it "propery handles unsigned values" do
        expect(type.encode(1))
          .to eq('0000000000000000000000000000000000000000000000000000000000000001')
      end

      it "fails if a negative value is given" do
        expect { type.encode(-1) }.to raise_error ArgumentError
      end
    end

    describe '#decode' do
      it "propery handles raw values" do
        expect(type.decode(:c, '0000000000000000000000000000000000000000000000000000000000000001'))
          .to eq(1)

        expect(type.decode(:c, 'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff'))
          .to eq(2**256 - 1) # max 256 bit integer value
      end
    end
  end
end
