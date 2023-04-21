$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pry'
require 'etherlite'
require 'webmock/rspec'

module SpecExtensions
  extend RSpec::SharedContext
  let(:client) { Etherlite.connect 'http://localhost:8565' }

  around(:each) do |example|
    if example.metadata[:integration]
      WebMock.allow_net_connect!
      snapshot_id = client.connection.evm_snapshot
      begin
        example.run
      ensure
        client.connection.evm_revert snapshot_id
        WebMock.disable_net_connect!
      end
    else
      example.run
    end
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.include SpecExtensions
end
