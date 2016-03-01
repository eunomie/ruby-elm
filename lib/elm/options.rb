require 'contracts'

module Elm
  # Error raised when trying to set a bad report format
  class BadReportFormatError < RuntimeError
  end

  # Options to run elm
  class Options
    include Contracts::Core
    include Contracts::Builtin

    FORMATS = [:normal, :json].freeze

    attr_reader :output, :yes, :report, :warn, :docs

    def initialize
      @output = 'index.html'
      @yes = false
      @report = :normal
      @warn = false
      @docs = nil
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
