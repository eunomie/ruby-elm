require 'contracts'
require 'tempfile'
require 'elm/runnable'
require 'elm/files'

module Elm
  # Compile a set of elm files with options
  class Compiler
    include Contracts::Core
    include Contracts::Builtin

    Contract Runnable => Compiler
    def self.with(runnable)
      Compiler.new runnable
    end

    Contract ArrayOf[String], KeywordArgs[with_options: Optional[Elm::Options]] => Files # rubocop:disable Metrics/LineLength
    def files(files_list, with_options: Elm::Options.new)
      Files.new @make, files_list, with_options
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract ArrayOf[String], KeywordArgs[with_options: { output: Maybe[String],
                                                          yes:    Maybe[Bool],
                                                          report: Maybe[Symbol],
                                                          warn:   Maybe[Bool],
                                                          docs:   Maybe[String] }] => Files # rubocop:disable Metrics/LineLength
    def files(files_list, with_options: {})
      files files_list, with_options: Elm::Options.with(with_options)
    end
    # rubocop:enable Lint/DuplicateMethods

    Contract String, KeywordArgs[with_options: Optional[Elm::Options]] => Files # rubocop:disable Metrics/LineLength
    def content(data, with_options: Elm::Options.new)
      Tempfile.open(['elm', '.elm']) do |tempfile|
        tempfile.write data
        files [tempfile.path], with_options: with_options
      end
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract String, KeywordArgs[with_options: { output: Maybe[String],
                                                 yes:    Maybe[Bool],
                                                 report: Maybe[Symbol],
                                                 warn:   Maybe[Bool],
                                                 docs:   Maybe[String] }] => Files # rubocop:disable Metrics/LineLength
    def content(data, with_options: {})
      content data, with_options: Elm::Options.with(with_options)
    end
    # rubocop:enable Lint/DuplicateMethods

    private

    Contract Elm::Runnable => Elm::Compiler
    def initialize(runnable)
      @make = runnable

      self
    end
  end
end
