module Etherlite::Abi
  class LoadType < PowerTypes::Command.new(:signature)
    MATCHER = /^(?:(?:(?<ty>uint|int|bytes)(?<b1>\d+)|(?<ty>uint|int|bytes)(?<b1>\d+)|(?<ty>fixed|ufixed)(?<b1>\d+)x(?<b2>\d+)|(?<ty>address|bool|uint|int|fixed|ufixed))(?:\[(?<dim>\d*)\]|)|(?<ty>bytes|string))$/

    def perform
      parts = MATCHER.match @signature
      raise ArgumentError, "Invalid argument type #{@signature}" if parts.nil?

      type = build_base_type parts
      build_array_type type, parts
    end

    private

    def build_base_type(_parts) # rubocop:disable Metrics/CyclomaticComplexity
      case _parts[:ty]
      when 'uint'     then Etherlite::Types::Integer.new(false, b1_256(_parts))
      when 'int'      then Etherlite::Types::Integer.new(true, b1_256(_parts))
      when 'ufixed'   then Etherlite::Types::Fixed.new(false, b1_128(_parts), b2_128(_parts))
      when 'fixed'    then Etherlite::Types::Fixed.new(true, b1_128(_parts), b2_128(_parts))
      when 'string'   then Etherlite::Types::String.new
      when 'address'  then Etherlite::Types::Address.new
      when 'bool'     then Etherlite::Types::Bool.new
      when 'bytes'
        if _parts[:b1].present?
          Etherlite::Types::Bytes.new(_parts[:b1].to_i)
        else
          Etherlite::Types::ByteString.new
        end
      end
    end

    def build_array_type(_base_type, _parts)
      return _base_type if _parts[:dim].nil?

      if _parts[:dim].empty?
        Etherlite::Types::ArrayDynamic.new _base_type
      else
        Etherlite::Types::ArrayFixed.new _base_type, _parts[:dim].to_i
      end
    end

    def b1_256(_parts)
      _parts[:b1].nil? ? 256 : _parts[:b1].to_i
    end

    def b1_128(_parts)
      _parts[:b1].nil? ? 128 : _parts[:b1].to_i
    end

    def b2_128(_parts)
      _parts[:b2].nil? ? 128 : _parts[:b2].to_i
    end
  end
end
