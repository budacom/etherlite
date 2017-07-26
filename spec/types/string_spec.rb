require 'spec_helper'

describe Etherlite::Types::String do
  let(:type) { described_class.new }

  describe '#encode' do
    it "returns a hex value that meets abi format requirements" do
      expect(type.encode('123abc'))
        .to eq("\
0000000000000000000000000000000000000000000000000000000000000006\
3132336162630000000000000000000000000000000000000000000000000000\
")
    end

    it "encodes values using UTF-8" do
      expect(type.encode('á'))
        .to eq("\
0000000000000000000000000000000000000000000000000000000000000002\
c3a1000000000000000000000000000000000000000000000000000000000000\
")
    end
  end

  describe '#decode' do
    it "parses an abi formatted hex value and returns the decoded string" do
      expect(type.decode(:con, "\
0000000000000000000000000000000000000000000000000000000000000003\
666f6f0000000000000000000000000000000000000000000000000000000000\
")).to eq "foo"
    end

    it "returns an UTF-8 encoded string" do
      expect(type.decode(:con, "\
0000000000000000000000000000000000000000000000000000000000000002\
c3a9000000000000000000000000000000000000000000000000000000000000\
")).to eq "é"
    end
  end
end
