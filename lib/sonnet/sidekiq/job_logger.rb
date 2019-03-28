# frozen_string_literal: true

require "sidekiq/job_logger"

module Album
  module Sidekiq
    class JobLogger < ::Sidekiq::JobLogger
      def call(item, queue)
        ::Sidekiq::Logging.with_context(source: item['class']) do
          begin
            start = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
            logger.debug(:start)
            yield
            logger.debug(:done, duration: elapsed(start))
          rescue
            logger.debug(:failure, duration: elapsed(start))
            raise
          end
        end
      end
    end
  end
end
