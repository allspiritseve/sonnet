# frozen_string_literal: true

module Sonnet
  module Logger
    def self.extended(logger)
      logger.formatter = Formatter
      logger.level = log_level
    end

    def self.log_level
      ::Logger.const_get((ENV["LOG_LEVEL"] || "INFO").upcase)
    end

    def with_context(context = {})
      formatter.current_context.push(context)
      yield self
    ensure
      formatter.current_context.pop
    end
  end
end
