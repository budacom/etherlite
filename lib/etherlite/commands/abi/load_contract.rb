module Etherlite::Abi
  class LoadContract < PowerTypes::Command.new(:artifact)
    def perform
      klass = Class.new(Etherlite::Contract::Base)

      define_class_getter klass, 'unlinked_bytecode', unlinked_bytecode

      abi_definitions.each do |definition|
        case definition['type']
        when 'function'
          define_function klass, definition
        when 'event'
          define_event klass, definition
        when 'constructor'
          define_class_getter klass, 'constructor', build_function_from_definition(definition)
        end
      end

      klass.functions.freeze
      klass.events.freeze
      ::Etherlite::EventProvider.register_contract_events klass
      klass
    end

    private

    def unlinked_bytecode
      @artifact['unlinked_binary'] || @artifact['bytecode'] || ''
    end

    def abi_definitions
      @artifact['abi'] || []
    end

    def define_function(_class, _definition)
      function = build_function_from_definition _definition

      _class.functions << function
      _class.class_eval do
        define_method(function.name.underscore) do |*params|
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

      define_class_getter event_class, 'original_name', _definition['name']
      define_class_getter event_class, 'inputs', event_inputs

      _class.events << event_class
      _class.const_set(_definition['name'], event_class)
    end

    def define_class_getter(_class, _name, _value)
      _class.class_eval do
        define_singleton_method(_name) { _value }
      end
    end

    def build_function_from_definition(_definition)
      Etherlite::Contract::Function.new(
        _definition['name'],
        _definition['inputs'].map do |input|
          Etherlite::Contract::FunctionInput.new(
            input['name'], LoadType.for(signature: input['type'])
          )
        end,
        (_definition['outputs'] || []).map { |input| LoadType.for signature: input['type'] },
        function_payable?(_definition),
        function_constant?(_definition)
      )
    end

    def function_payable?(_definition)
      return _definition['payable'] if _definition.key? 'payable'

      _definition['stateMutability'] == 'payable'
    end

    def function_constant?(_definition)
      return _definition['constant'] if _definition.key? 'constant'

      _definition['stateMutability'] == 'pure' || _definition['stateMutability'] == 'view'
    end
  end
end
