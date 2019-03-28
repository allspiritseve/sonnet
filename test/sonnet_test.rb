require "test_helper"
require "logger"

class SonnetTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sonnet::VERSION
  end

  def test_json_logging
    io = StringIO.new
    logger = Logger.new(io)
    logger.extend(Sonnet::Logger)
    logger.info("What's the story, morning glory?")
    line = JSON.parse(io.string)
    assert_equal line.fetch("message"), "What's the story, morning glory?"
  end
end
