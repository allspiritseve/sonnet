# frozen_string_literal: true

require "test_helper"

module Sonnet
  class FormatterTest < Minitest::Test
    def test_call
      now = Time.now
      with_program_name("sidekiq 5.2.5 diaco [0 of 10 busy]") do
        log_line = JSON.parse(formatter.call("INFO", now, nil, "some message"), symbolize_names: true)
        assert_equal log_line, {
          program: "sidekiq",
          level: "info",
          timestamp: now.iso8601(3),
          pid: $$,
          message: "some message"
        }
      end
    end

    protected

    def formatter
      Formatter
    end

    def with_program_name(name)
      original_program_name = $0
      $0 = name
      yield if block_given?
    ensure
      $0 = original_program_name
    end
  end
end
