# frozen_string_literal: true

module Sonnet
  class Formatter
    TIMESTAMP_FORMAT = "%FT%T.%LZ"

    def self.call(*args)
      severity, time, progname, data, *other = args
      new(severity, time, progname, data).to_json
    rescue => e
      debugger
      raise e
    end

    def initialize(severity, time, progname, data)
      @severity = severity
      @time = time
      @progname = progname
      @data = data
    end

    def program
      @progname || File.basename($0)
    end

    def timestamp
      (@time || Time.now).utc.strftime(TIMESTAMP_FORMAT)
    end

    def data
      case @data
      when Exception
        serialize_exception(@data)
      when Hash
        @data
      else
        serialize_string(@data)
      end
    end

    def level
      @severity&.downcase
    end

    def hostname
      @hostname || Socket.gethostname.force_encoding('UTF-8')
    end

    def serialize_exception(exception)
      debugger
      {
        kind: exception.class.name,
        message: exception.to_s,
        stack: exception.backtrace&.slice(0, 3)
      }
    end

    def serialize_string(string)
      { message: string.to_s }
    end

    def pid
      @pid || $$
    end

    def as_json
      {
        program: program,
        hostname: hostname,
        level: level,
        timestamp: timestamp,
        pid: pid
      }.merge(data).compact
    end

    def to_json
      as_json.to_json + "\n"
    end
  end
end
