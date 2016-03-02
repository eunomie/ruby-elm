require 'contracts'

module Elm
  # rubocop:disable Metrics/ClassLength
  # Error raised when trying to set a bad report format
  class BadReportFormatError < RuntimeError
  end

  # Options to run elm
  class Options
    include Contracts::Core
    include Contracts::Builtin

    Contract KeywordArgs[output: Optional[String],
                         yes:    Optional[Bool],
                         report: Optional[Symbol],
                         warn:   Optional[Bool],
                         docs:   Optional[Maybe[String]]] => Options
    def self.with(output: 'index.html', yes: false, report: :normal,
                  warn: false, docs: nil)
      opts = Options.new
      opts.output = output
      opts.yes = yes
      opts.report = report
      opts.warn = warn
      opts.docs = docs unless docs.nil?
      opts
    end

    Contract Options => Options
    def self.clone(opts)
      Options.with(output: opts.output,
                   yes: opts.yes,
                   report: opts.report,
                   warn: opts.warn,
                   docs: opts.docs)
    end

    FORMATS = [:normal, :json].freeze

    attr_reader :output, :yes, :report, :warn, :docs

    Contract None => Options
    def initialize
      @output = 'index.html'
      @yes = false
      @report = :normal
      @warn = false
      @docs = nil

      self
    end

    # rubocop:disable Style/TrivialAccessors
    Contract String => String
    def output=(value)
      # check output is valid
      @output = value
    end

    Contract Bool => Bool
    def yes=(value)
      @yes = value
    end

    Contract Symbol => Symbol
    def report=(value)
      if FORMATS.index(value).nil?
        raise BadReportFormatError, "'#{value}' is not a valid report format"
      end
      @report = value
    end

    Contract Bool => Bool
    def warn=(value)
      @warn = value
    end

    Contract String => String
    def docs=(value)
      @docs = value
    end
    # rubocop:enable Style/TrivialAccessors

    Contract None => ArrayOf[String]
    def to_a
      res = []
      push_output res
      push_yes res
      push_report res
      push_warn res
      push_docs res
      res
    end

    Contract String => Options
    def with_output(output)
      opts = Options.clone self
      opts.output = output
      opts
    end

    Contract None => Options
    def with_yes
      opts = Options.clone self
      opts.yes = true
      opts
    end

    Contract Symbol => Options
    def with_report(report)
      opts = Options.clone self
      opts.report = report
      opts
    end

    Contract None => Options
    def with_warn
      opts = Options.clone self
      opts.warn = true
      opts
    end

    Contract String => Options
    def with_docs(docs)
      opts = Options.clone self
      opts.docs = docs
      opts
    end

    private

    Contract ArrayOf[String] => Maybe[ArrayOf[String]]
    def push_output(res)
      res << '--output' && res << @output unless @output == 'index.html'
    end

    Contract ArrayOf[String] => Maybe[ArrayOf[String]]
    def push_yes(res)
      res << '--yes' if @yes
    end

    Contract ArrayOf[String] => Maybe[ArrayOf[String]]
    def push_report(res)
      res << '--report' && res << @report.to_s unless @report == :normal
    end

    Contract ArrayOf[String] => Maybe[ArrayOf[String]]
    def push_warn(res)
      res << '--warn' if @warn
    end

    Contract ArrayOf[String] => Maybe[ArrayOf[String]]
    def push_docs(res)
      res << '--docs' && res << @docs unless @docs.nil?
    end
  end
end
