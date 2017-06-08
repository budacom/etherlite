module Etherlite::Abi
  class LoadContract < PowerTypes::Command.new(:json)
    def perform
      klass = Class.new(Etherlite::Contract::Base)

      abi_definitions.each do |definition|
        case definition['type']
        when 'function'
          define_function klass, definition
        when 'event'
          define_event klass, definition
        end
      end

      klass.functions.freeze
      klass.events.freeze
      klass
    end

    private

    def abi_definitions
      @json['abi'] || []
    end

    def define_function(_class, _definition)
      function_args = _definition['inputs'].map { |input| LoadType.for signature: input['type'] }
      function = Etherlite::Contract::Function.new(
        _definition['name'],
        function_args,
        payable: _definition['payable'],
        constant: _definition['constant']
      )

      _class.functions << function
      _class.class_eval do
        define_method(_definition['name'].underscore) do |*params|
          account = (params.last.is_a?(Hash) && params.last[:as]) || default_account

          raise ArgumentError, 'must provide a source account' if account.nil?
          account.call address, function, *params
        end
      end
    end

    def define_event(_class, _definition)
      event_inputs = _definition['inputs'].map do |input|
        Etherlite::Contract::EventInput.new(
          input['name'], LoadType.for(signature: input['type']), input['indexed']
        )
      end

      event_class = Class.new(Etherlite::Contract::EventBase) do
        event_inputs.each do |input|
          define_method(input.name) { attributes[input.original_name] }
        end
      end

      event_class.instance_variable_set(:@original_name, _definition['name'])
      event_class.instance_variable_set(:@inputs, event_inputs)

      _class.events << event_class
      _class.const_set(_definition['name'], event_class)
    end
  end
end
