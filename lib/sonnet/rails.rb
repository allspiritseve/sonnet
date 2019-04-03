# frozen_string_literal: true

require 'sonnet'

module Sonnet
  class Rails < ::Rails::Engine
    config.before_configuration do
      require "sonnet/rails_monkeypatch"
    end
  end

  module RailsLogger
    include ActiveSupport::LoggerThreadSafeLevel
    include LoggerSilence

    def self.included(base)
      base.singleton_class.prepend (Module.new do
        def extended(logger)
          super(logger)
          logger.after_initialize if logger.respond_to?(:after_initialize)
        end
      end)
    end

    def tagged(*tags, &block)
      if tags.present?
        with_context(tags: tags, &block)
      else
        yield self
      end
    end
  end

  module Logger
    include RailsLogger
  end
end
