require 'spec_helper'

describe Etherlite::Connection do
  let(:connection) { described_class.new uri }

  context "when uri uses http scheme" do
    let(:uri) { URI('http://www.etherlite.com') }
    let(:status_code) { 200 }
    let(:response) { { 'result' => 'foo' }.to_json }

    before do
      stub_request(:any, /^www\.etherlite\.com(.*)?/)
        .to_return(body: response, status: status_code)
    end

    describe "#ipc_call" do
      it "performs a json-rpc call with the given method and parameters" do
        connection.ipc_call('method', 'param1', 'param2')

        assert_requested(
          :post,
          'http://www.etherlite.com/',
          body: hash_including(jsonrpc: "2.0", method: 'method', params: ['param1', 'param2']),
          times: 1
        )
      end

      it "returns the content of the response's 'result' attribute" do
        expect(connection.ipc_call('method')).to eq 'foo'
      end
    end

    context "and response includes an 'error' attribute" do
      let(:response) { { error: { code: 1, message: 'notgood' } }.to_json }

      it "fails with a NodeError exception" do
        expect { connection.ipc_call('method') }.to raise_error Etherlite::NodeError
      end
    end

    context "and response has a non-200 status code" do
      let(:status_code) { 500 }

      it "fails with a RPCError exception" do
        expect { connection.ipc_call('method') }.to raise_error Etherlite::RPCError
      end
    end
  end
end
