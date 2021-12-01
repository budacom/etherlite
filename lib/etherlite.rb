require "digest/keccak"
require "active_support/all"
require "forwardable"
require "net/http"
require "power-types"

require "etherlite/version"

require "etherlite/api/address"
require "etherlite/api/node"
require "etherlite/api/rpc"
require "etherlite/api/parity_rpc"

require "etherlite/support/array"

require "etherlite/types/base"
require "etherlite/types/address"
require "etherlite/types/array_dynamic"
require "etherlite/types/array_fixed"
require "etherlite/types/boolean"
require "etherlite/types/byte_string"
require "etherlite/types/bytes"
require "etherlite/types/fixed"
require "etherlite/types/integer"
require "etherlite/types/string"

require "etherlite/contract/base"
require "etherlite/contract/event_base"
require "etherlite/contract/event_input"
require "etherlite/contract/function"
require "etherlite/contract/function_input"

require "etherlite/errors"
require "etherlite/configuration"
require "etherlite/event_provider"
require "etherlite/abi"
require "etherlite/utils"
require "etherlite/connection"
require "etherlite/transaction"
require "etherlite/nonce_manager"
require "etherlite/account/base"
require "etherlite/account/local"
require "etherlite/account/private_key"
require "etherlite/account/anonymous"
require "etherlite/address"
require "etherlite/client"

module Etherlite
  extend Api::Node

  def self.valid_address?(_value)
    Utils.valid_address? _value
  end

  def self.connect(_url, _options = {})
    _url = URI(_url) unless _url.is_a? URI

    options = config.default_connection_options
    options = options.merge _options.slice options.keys

    Client.new Connection.new(_url, options)
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.logger
    config.logger
  end

  def self.configure(_options = nil, &_block)
    config.assign_attributes(_options) unless _options.nil?
    _block.call(config) unless _block.nil?
  end

  def self.connection
    @connection ||= Connection.new(URI(config.url), config.default_connection_options)
  end
end

require "etherlite/railtie" if defined? Rails
