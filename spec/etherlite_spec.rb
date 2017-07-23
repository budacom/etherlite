require 'spec_helper'

describe Etherlite do
  it 'has a version number' do
    expect(Etherlite::VERSION).not_to be nil
  end

  describe ".connection" do
    it "returns the default connection" do
      expect(Etherlite.connection).to be_a Etherlite::Connection
    end
  end
end
