require "test_helper"

class SonnetTest < Minitest::Test
  Error = Class.new(StandardError)

  def test_log_info
    logger.info("What's the story, morning glory?")
    assert_log_line log[0], level: "info", message: "What's the story, morning glory?"
  end

  def test_log_debug
    logger.debug("this should not be logged")
    assert_nil log[0]
    logger.level = Logger::DEBUG
    logger.debug("this should be logged")
    assert_log_line log[0], level: "debug", message: "this should be logged"
  end

  def test_log_exception
    logger.error(Error.new("something went wrong"))
    assert_log_line log[0], message: "something went wrong"
  end

  def test_log_with_context
    logger.with_context(color: "blue") { logger.info("What's the story, morning glory?") }
    logger.info("definitely maybe")
    assert_log_line log[0], color: "blue", message: "What's the story, morning glory?"
    assert_log_line log[1], message: "definitely maybe"
  end

  def test_new
    logger = Sonnet::Logger.new(Logger.new(io))
    assert_equal logger.formatter, Sonnet::Formatter
    logger.info("What's the story, morning glory?")
    assert_log_line log[0], level: "info", message: "What's the story, morning glory?"
  end

  def assert_log_line(actual, expected)
    assert_equal expected, actual.slice(*expected.keys)
  end

  def logger
    @logger ||= Logger.new(io).tap { |logger| logger.extend(Sonnet::Logger) }
  end

  def io
    @io ||= StringIO.new
  end

  def log
    io.string.each_line.map { |line| JSON.parse(line, symbolize_names: true) }
  end
end
