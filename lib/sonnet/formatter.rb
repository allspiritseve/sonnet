# frozen_string_literal: true

require 'json'
require 'time'

module Sonnet
  class Formatter
    def self.call(severity, time, progname, data)
      new(severity, time, progname, data).to_json
    end

    def self.current_context
      Thread.current[:sonnet_current_context] ||= []
    end

    def initialize(severity, time, progname, data)
      @severity = severity
      @time = time
      @progname = progname
      @data = data
      @tags = []
    end

    def program
      @progname || File.basename($0, '.rb').split(' ')[0]
    end

    def timestamp
      (@time || Time.now).utc.iso8601(3)
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

    def serialize_exception(exception)
      {
        kind: exception.class.name,
        message: exception.to_s,
        stack: exception.backtrace&.slice(0, 3)
      }
    end

    def serialize_string(string)
      { message: string.to_s }
    end

    def context
      self.class.current_context.inject({}) do |memo, context|
        tags = memo.fetch(:tags, []) + [*context.delete(:tags)].compact
        tag_context = tags.empty? ? {} : { tags: tags }
        memo.merge(context).merge(tag_context)
      end
    end

    def level
      @severity&.downcase
    end

    # def hostname
    #   @hostname || Socket.gethostname.force_encoding('UTF-8')
    # end

    def pid
      $$
    end

    def as_json
      {
        program: program,
        # hostname: hostname,
        level: level,
        timestamp: timestamp,
        pid: pid
      }.merge(context).merge(data).compact
    end

    def to_json(opts = nil)
      as_json.to_json(opts) + "\n"
    end
  end
end
