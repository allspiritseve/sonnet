# frozen_string_literal: true

require "sidekiq/exception_handler"
require "sonnet/serializer"

module Sonnet
  module Sidekiq
    module ExceptionHandler
      def self.extended(base)
        ::Sidekiq::ExceptionHandler::Logger.prepend(Logger)
      end

      module Logger
        def call(ex, ctxHash)
          ::Sidekiq.logger.warn(
            exception: ex,
            message: ctxHash["context"],
            job: ctxHash[:job]
          )
        end
      end
    end
  end
end
