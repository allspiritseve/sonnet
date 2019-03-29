require "sidekiq/job_logger"

module SidekiqLogging
  def self.job_context(job_hash)
    {
      worker_class: job_hash["wrapped"] || job_hash["class"],
      jid: job_hash["jid"]
    }
  end

  class JobLogger < Sidekiq::JobLogger
    def call(job_hash, queue, &block)
      Sidekiq.logger.with_context(SidekiqLogging.job_context(job_hash)) do
        begin
          start = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
          Sidekiq.logger.debug(message: "start")
          yield
          Sidekiq.logger.debug(message: "done", duration: elapsed(start))
        rescue
          Sidekiq.logger.debug(message: "failure", duration: elapsed(start))
          raise
        end
      end
    end
  end

  class ErrorHandler
    def call(exception, context_hash)
      Sidekiq.logger.with_context(SidekiqLogging.job_context(context_hash[:job])) do
        Sidekiq.logger.warn(exception)
      end
    end
  end
end

Sidekiq.configure_server do |config|
  Sidekiq::Logging.logger = Rails.logger
  config.options[:job_logger] = SidekiqLogging::JobLogger
  config.error_handlers.pop
  config.error_handlers << SidekiqLogging::ErrorHandler.new
end
