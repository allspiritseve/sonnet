require "test_helper"
require "logger"

class SonnetTest < Minitest::Test
  Error = Class.new(StandardError)

  def test_that_it_has_a_version_number
    refute_nil ::Sonnet::VERSION
  end

  def test_json_logging
    logger.info("What's the story, morning glory?")
    assert_equal log[0].fetch("message"), "What's the story, morning glory?"
  end

  def test_exception_logging
    logger.error(Error.new("something went wrong"))
    assert_equal log[0]["message"], "something went wrong"
  end

  def logger
    @logger ||= Logger.new(io).tap { |logger| logger.extend(Sonnet::Logger) }
  end

  def io
    @io ||= StringIO.new
  end

  def log
    io.string.each_line.map { |line| JSON.parse(line) }
  end
end
