# frozen_string_literal: true

require "sidekiq/job_logger"

module Sonnet
  module Sidekiq
    class JobLogger < ::Sidekiq::JobLogger
      def call(item, queue)
        ::Sidekiq::Logging.with_context(source: item['class']) do
          begin
            start = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
            logger.debug(message: "start")
            yield
            logger.debug(message: "done", duration: elapsed(start))
          rescue
            logger.debug(message: "failure", duration: elapsed(start))
            raise
          end
        end
      end
    end
  end
end
