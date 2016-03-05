require 'contracts'
require 'mkmf'
require 'open3'

module Elm
  # Error raised if executable not found
  class ExecutableNotFoundError < RuntimeError
  end

  # Successful status
  class RunSuccess
    include Contracts::Core
    include Contracts::Builtin

    attr_reader :stdout

    Contract String => RunSuccess
    def initialize(stdout)
      @stdout = stdout

      self
    end
  end

  # Fail status
  class RunError
    include Contracts::Core
    include Contracts::Builtin

    attr_reader :stdout, :stderr

    Contract String, KeywordArgs[with_error: Optional[String]] => RunError
    def initialize(stdout, with_error: '')
      @stdout = stdout
      @stderr = with_error

      self
    end
  end

  # Run command
  class Runnable
    include Contracts::Core
    include Contracts::Builtin

    RunStatus = Or[RunSuccess, RunError]

    Contract String => Runnable
    def initialize(command)
      @command = command

      unless exists?
        raise ExecutableNotFoundError,
              "Please install executable '#{@command}'"
      end

      self
    end

    Contract None => RunStatus
    def run
      run []
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract ArrayOf[String] => RunStatus
    def run(options)
      cmd = [@command] + options
      Open3.popen3(*cmd) do |_i, o, e, t|
        @out = o.gets || ''
        @err = e.gets || ''
        if t.value.success?
          RunSuccess.new @out
        else
          RunError.new @out, with_error: @err
        end
      end
    end
    # rubocop:enable Lint/DuplicateMethods

    private

    Contract None => Bool
    def exists?
      !find_executable0(@command).nil?
    end
  end
end
