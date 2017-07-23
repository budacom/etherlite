require "digest/sha3"
require "active_support/all"
require "power-types"

require "etherlite/version"

require "etherlite/api/address"
require "etherlite/api/node"
require "etherlite/api/rpc"

require "etherlite/types/base"
require "etherlite/types/address"
require "etherlite/types/array_base"
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

require "etherlite/errors"
require "etherlite/configuration"
require "etherlite/abi"
require "etherlite/utils"
require "etherlite/connection"
require "etherlite/transaction"
require "etherlite/nonce_manager"
require "etherlite/pk_account"
require "etherlite/account"
require "etherlite/address"
require "etherlite/client"

module Etherlite
  extend Api::Node

  def self.valid_address?(_value)
    Utils.valid_address? _value
  end

  def self.connect(_url, chain_id: nil)
    _url = URI(_url) unless _url.is_a? URI

    Client.new Connection.new(_url, chain_id)
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
    @connection ||= Connection.new(URI(config.url), config.chain_id)
  end
end

require "etherlite/railtie" if defined? Rails
