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
  end
end
