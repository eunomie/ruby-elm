require 'contracts'
require 'tempfile'
require 'elm/runnable'
require 'elm/options'

module Elm
  # Error raised if run fail
  class CompilerError < RuntimeError
  end

  # Compilation output including status
  class CompileOutput
    include Contracts::Core
    include Contracts::Builtin

    attr_reader :output, :run_status

    Contract String, RunSuccess => CompileOutput
    def initialize(output, run_status)
      @output = output
      @run_status = run_status

      self
    end

    Contract None => String
    def stdout
      @run_status.stdout
    end

    Contract None => String
    def stderr
      @run_status.stderr
    end
  end

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

    Contract None => CompileOutput
    def to_s
      content = ''
      run_status = nil
      Tempfile.open(['elm', '.js']) do |tempfile|
        run_status = compile @options.with_output(tempfile.path)
        content = File.read tempfile
      end
      CompileOutput.new content, run_status
    end

    Contract None => CompileOutput
    def to_file
      run_status = compile
      CompileOutput.new @options.output, run_status
    end

    private

    Contract None => RunSuccess
    def compile
      compile @options
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract Elm::Options => RunSuccess
    def compile(options)
      status = @make.run(@files + options.to_a)
      raise(CompilerError, status.stderr) if status.is_a? RunError
      status
    end
    # rubocop:enable Lint/DuplicateMethods
  end
end
