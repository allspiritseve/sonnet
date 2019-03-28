# frozen_string_literal: true

require "sonnet/formatter"
require "sonnet/logger"
require "sonnet/version"

require "json"

module Sonnet
end

require "sonnet/rails" if defined?(::Rails::Engine)
