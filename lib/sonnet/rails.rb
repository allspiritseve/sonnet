# frozen_string_literal: true

require 'sonnet'
require 'concurrent'
require 'fiber'

module Sonnet
  class Rails < ::Rails::Engine
    config.before_configuration do
      require "sonnet/rails_monkeypatch"
    end
  end

  module RailsLogger
    def self.included(base)

      base.singleton_class.prepend (Module.new do
        def extended(logger)
          super(logger)
          logger.after_initialize if logger.respond_to?(:after_initialize)
        end
      end)
    end

    def after_initialize
      @local_levels = Concurrent::Map.new(initial_capacity: 2)
    end

    def tagged(*tags, &block)
      if tags.present?
        with_context(tags: tags.flatten, &block)
      else
        yield self
      end
    end

    def local_log_id
      Fiber.current.__id__
    end

    def local_level
      @local_levels[local_log_id]
    end

    def local_level=(level)
      if level
        @local_levels[local_log_id] = level
      else
        @local_levels.delete(local_log_id)
      end
    end

    def level
      local_level || super
    end
  end

  module RailsFormatter
    def current_tags
      current_context.inject([]) do |memo, context|
        memo + [*context[:tags]].flatten.compact
      end
    end
  end

  module Logger
    include RailsLogger
  end

  class Formatter
    extend RailsFormatter
  end
end
