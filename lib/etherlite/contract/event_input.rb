module Etherlite::Contract
  class EventInput
    attr_reader :original_name, :type

    def initialize(_original_name, _type, _indexed)
      @original_name = _original_name
      @type = _type
      @indexed = _indexed
    end

    def name
      @name ||= @original_name.underscore
    end

    def indexed?
      @indexed
    end
  end
end
