require 'spec_helper'

describe Etherlite::Types::Boolean do
  let(:type) { described_class.new }

  describe '#encode' do
    it "translates true as 1 and false as 0" do
      expect(type.encode(true))
        .to eq('0000000000000000000000000000000000000000000000000000000000000001')

      expect(type.encode(false))
        .to eq('0000000000000000000000000000000000000000000000000000000000000000')
    end

    it "fails if given value is not true nor false" do
      expect { type.encode(:teapot) }.to raise_error ArgumentError
    end
  end

  describe '#decode' do
    it "translates 1 as true and 0 as false" do
      expect(type.decode(:c, '0000000000000000000000000000000000000000000000000000000000000001'))
        .to be true

      expect(type.decode(:c, '0000000000000000000000000000000000000000000000000000000000000000'))
        .to be false
    end
  end
end
