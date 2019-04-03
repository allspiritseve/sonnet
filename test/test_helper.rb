# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require 'minitest/autorun'
require 'minitest/reporters'
require 'byebug'
require 'logger'

Minitest::Reporters.use! [Minitest::Reporters::ProgressReporter.new]

require "sonnet"

module LoggingHelpers
  def logger
    @logger ||= Logger.new(io)
  end

  def io
    @io ||= StringIO.new
  end

  def assert_log_line(actual, expected)
    assert_equal expected, actual.slice(*expected.keys)
  end

  def log
    io.string.each_line.map { |line| JSON.parse(line, symbolize_names: true) }
  end

  def messages(lines)
    lines.map { |line| line[:message] }
  end
end

class Minitest::Test
  include LoggingHelpers
end
