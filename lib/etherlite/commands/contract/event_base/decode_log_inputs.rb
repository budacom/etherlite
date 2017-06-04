class Etherlite::Contract::EventBase
  class DecodeLogInputs < PowerTypes::Command.new(:connection, :inputs, :json)
    def perform
      indexed = []
      non_indexed = []
      attributes = {}

      @inputs.each { |i| (i.indexed? ? indexed : non_indexed) << i }

      @json['data'][2..-1].scan(/.{64}/).each_with_index do |data, i|
        attributes[non_indexed[i].name] = non_indexed[i].type.decode(@connection, data)
      end

      @json['topics'][1..-1].each_with_index do |topic, i|
        attributes[indexed[i].name] = indexed[i].type.decode(@connection, topic[2..-1])
      end

      attributes
    end
  end
end
