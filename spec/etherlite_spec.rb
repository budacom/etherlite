require 'spec_helper'

describe Etherlite do
  it 'has a version number' do
    expect(Etherlite::VERSION).not_to be nil
  end

  describe '.connect' do
    it 'passes the base uri to the new connection' do
      client = Etherlite.connect('http://foo.bar')
      expect(client.connection.uri.to_s).to eq 'http://foo.bar'
    end

    it 'passes the chain_id option to the new connection' do
      client = Etherlite.connect('http://foo.bar', chain_id: 123)
      expect(client.connection.chain_id).to eq 123
    end
  end

  describe '.connection' do
    it 'returns the default connection' do
      expect(Etherlite.connection).to be_a Etherlite::Connection
    end
  end
end
