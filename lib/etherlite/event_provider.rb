module Etherlite
  module EventProvider
    extend self

    def register_contract_events(_contract_class)
      _contract_class.events.each { |e| register_event e }
    end

    def register_event(_event)
      event_by_topic[_event.topic] = _event
    end

    def parse_raw_log(_connection, _raw_log)
      event = event_by_topic[_raw_log["topics"].first]
      return nil if event.nil?
      event.decode(_connection, _raw_log)
    end

    def parse_raw_logs(_connection, _raw_logs)
      _raw_logs.map { |e| parse_raw_log(_connection, e) }.reject &:nil?
    end

    private

    def event_by_topic
      @event_by_topic ||= {}
    end
  end
end
