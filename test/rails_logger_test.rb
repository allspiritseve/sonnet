# frozen_string_literal: true

require 'test_helper'

# Stub out some Rails constants and methods
Rails = Module.new
Rails::Engine = Class.new do
  def self.config
    OpenStruct.new
  end
end
ActiveSupport = Module.new
ActiveSupport::LoggerThreadSafeLevel = Module.new
LoggerSilence = Module.new

class Array
  def present?
    length > 0
  end
end

require 'sonnet/rails'

class RailsLoggerTest < Minitest::Test
  def setup
    logger.extend(Sonnet::Logger)
  end

  def test_tagged_string
    logger.tagged('request_id') do
      logger.info("What's the story, morning glory?")
    end
    assert_equal log[0][:tags], ['request_id']
  end

  def test_tagged_array
    logger.tagged(['request_id']) do
      logger.info("What's the story, morning glory?")
    end
    assert_equal log[0][:tags], ['request_id']
  end
end
