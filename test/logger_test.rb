# frozen_string_literal: true

require "test_helper"

class LoggerTest < Minitest::Test
  Error = Class.new(StandardError)

  def setup
    logger.extend(Sonnet::Logger)
  end

  def test_log_info
    logger.info("What's the story, morning glory?")
    assert_equal log[0].slice(:level, :message), level: "info", message: "What's the story, morning glory?"
  end

  def test_log_debug
    logger.debug("this should not be logged")
    assert_nil log[0]
    logger.level = Logger::DEBUG
    logger.debug("this should be logged")
    assert_equal log[0].slice(:level, :message), level: "debug", message: "this should be logged"
  end

  def test_log_exception
    logger.error(Error.new("something went wrong"))
    assert_equal messages(log), ["something went wrong"]
  end

  def test_log_with_context
    logger.with_context(color: "blue") { logger.info("What's the story, morning glory?") }
    logger.info("definitely maybe")
    assert_equal log[0].slice(:color, :message), color: "blue", message: "What's the story, morning glory?"
    assert_equal log[1].slice(:color, :message), message: "definitely maybe"
  end
end
