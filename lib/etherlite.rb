require "digest/sha3"
require "active_support/all"
require "power-types"

require "etherlite/version"

require "etherlite/api/address"
require "etherlite/api/node"

require "etherlite/types/base"
require "etherlite/types/address"
require "etherlite/types/array_base"
require "etherlite/types/array_dynamic"
require "etherlite/types/array_fixed"
require "etherlite/types/bool"
require "etherlite/types/byte_string"
require "etherlite/types/bytes"
require "etherlite/types/fixed"
require "etherlite/types/integer"
require "etherlite/types/string"

require "etherlite/contract/base"
require "etherlite/contract/event_base"
require "etherlite/contract/event_input"
require "etherlite/contract/function"

require "etherlite/abi"
require "etherlite/utils"
require "etherlite/connection"
require "etherlite/account"
require "etherlite/address"
require "etherlite/client"

module Etherlite
  extend Api::Node

  def self.valid_address?(_value)
    Utils.valid_address? _value
  end

  def self.connect(_host, _port) # connect to specific socket/host/port/
    Client.new
  end

  def self.connection
    @connection ||= begin
      # TODO: extract default connection options from somewhere...
      Connection.new
    end
  end
end
