require 'spec_helper'

describe Etherlite::Utils do
  let(:utils) { described_class }

  describe '.valid_address?' do
    it "only validates prefix, address length and characters if no caps" do
      expect(utils.valid_address?('0xabcdef1234567890abcdef1234567890abcdef12')).to be true
      expect(utils.valid_address?('0xabcdef1234567890abcdef1234567890abcdef1')).to be false
      expect(utils.valid_address?('0xabcdef1234567890abcdef1234567890abcdef123')).to be false
      expect(utils.valid_address?('abcdef1234567890abcdef1234567890abcdef12')).to be false
      expect(utils.valid_address?('0xabcdef1234567890abcdef1234567890abcdef1x')).to be false
    end

    it "validates checksum if a capital letter is provided" do
      expect(utils.valid_address?('0xAbcdef1234567890abcdef1234567890abcdef12')).to be false
      expect(utils.valid_address?('0x3d535CA9623E7c1e1D93F7A965ea853675120418')).to be true
    end
  end
end
