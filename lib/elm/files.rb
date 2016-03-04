require 'contracts'
require 'tempfile'
require 'elm/runnable'
require 'elm/options'

module Elm
  # Elm files to be compiled
  class Files
    include Contracts::Core
    include Contracts::Builtin

    Contract Elm::Runnable, ArrayOf[String], Elm::Options => Elm::Files
    def initialize(make, files, options)
      @make = make
      @files = files
      @options = options.with_yes

      self
    end

    Contract None => String
    def to_s
      content = ''
      Tempfile.open(['elm', '.js']) do |tempfile|
        compile @options.with_output(tempfile.path)
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
    Contract Elm::Options => String
    def compile(options)
      status = @make.run(@files + options.to_a)
      raise CompilerError unless status
      options.output
    end
    # rubocop:enable Lint/DuplicateMethods
  end
end
