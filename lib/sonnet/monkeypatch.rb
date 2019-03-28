if ActiveSupport::VERSION::MAJOR < 6
  # Monkeypatch in Rails 6 ActiveSupport::TaggedLogging initializer.
  # Solves problem in which the TaggedLogging initializer modifies an existing logger
  # by injecting its own functionality in.
  module ActiveSupport
    module TaggedLogging
      def self.new(logger)
        logger = logger.dup

        if logger.formatter
          logger.formatter = logger.formatter.dup
        else
          # Ensure we set a default formatter so we aren't extending nil!
          logger.formatter = ActiveSupport::Logger::SimpleFormatter.new
        end

        logger.formatter.extend Formatter
        logger.extend(self)
      end
    end
  end

  # Log actual exception instead of a string
  module ActionDispatch
    class DebugExceptions
      private

      def log_error(_request, wrapper)
        ActiveSupport::Deprecation.silence do
          ActionController::Base.logger.fatal(wrapper.exception)
        end
      end
    end
  end
else
  ActiveSupport::Deprecation.warn('No longer need to monkeypatch ActiveSupport::TaggedLogging!')
  ActiveSupport::Deprecation.warn('No longer need to monkeypatch ActionDispatch::DebugExceptions!')
end

