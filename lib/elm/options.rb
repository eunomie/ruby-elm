require 'contracts'

module Elm
  # Options to run elm
  class Options
    include Contracts::Core
    include Contracts::Builtin

    REPORTS = [:normal, :json].freeze

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
      raise Error if REPORTS.index(value).nil?
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
