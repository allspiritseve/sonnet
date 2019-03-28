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
  end
end
