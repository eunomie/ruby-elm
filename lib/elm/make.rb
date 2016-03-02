require 'contracts'
require 'elm/opt_parser'
require 'open3'
require 'tempfile'

module Elm
  # elm-make wrapper
  class Make
    include Contracts::Core
    include Contracts::Builtin

    Contract ArrayOf[String], KeywordArgs[with_options: Optional[Elm::Options]] => Make # rubocop:disable Metrics/LineLength
    def self.files(files_list, with_options: Elm::Options.new)
      with_options.yes = true
      Make.new(files_list, with_options)
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract ArrayOf[String], KeywordArgs[with_options: { output: Maybe[String],
                                                          yes:    Maybe[Bool],
                                                          report: Maybe[Symbol],
                                                          warn:   Maybe[Bool],
                                                          docs:   Maybe[String] }] => Make # rubocop:disable Metrics/LineLength
    def self.files(files_list, with_options: nil)
      files files_list, with_options: Elm::Options.with(with_options)
    end
    # rubocop:enable Lint/DuplicateMethods

    Contract None => String
    def to_s
      content = ''
      Tempfile.open(['elm', '.js']) do |tempfile|
        compile @options.with_output(tempfile.path).with_yes
        content = File.read tempfile
      end
      content
    end

    Contract None => String
    def to_file
      compile
    end

    private

    Contract None => String
    def compile
      compile @options
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract Options => String
    def compile(options)
      cmd = ['elm-make'] + @files + options.to_a
      Open3.popen3(*cmd) do |_i, _o, _e, t|
        status = t.value
        puts cmd.join(' ') unless status.success?
      end
      options.output
    end
    # rubocop:enable Lint/DuplicateMethods

    Contract ArrayOf[String], Elm::Options => Elm::Make
    def initialize(files, options)
      @files = files
      @options = options

      self
    end
  end
end
