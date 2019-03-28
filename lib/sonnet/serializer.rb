# frozen_string_literal: true

module Sonnet
  module Serializer
    def self.serialize_exception(exception)
      {
        kind: exception.class.name,
        message: exception.to_s,
        stack: exception.backtrace&.slice(0, 3)
      }
    end
  end
end
