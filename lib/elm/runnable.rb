require 'contracts'
require 'mkmf'
require 'open3'

module Elm
  # Error raised if executable not found
  class ExecutableNotFoundError < RuntimeError
  end

  # Status if execution of Runnable
  class RunStatus
    include Contracts::Core
    include Contracts::Builtin

    attr_reader :stdout, :stderr

    Contract String, KeywordArgs[with_error: Optional[String]] => RunStatus
    def initialize(stdout, with_error: '')
      @stdout = stdout
      @stderr = with_error

      self
    end
  end

  # Status when execution is successful
  class RunSuccess < RunStatus
  end

  # Status when execution fail
  class RunError < RunStatus
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
        out = o.read || ''
        err = e.read || ''
        if t.value.success?
          RunSuccess.new out, with_error: err
        else
          RunError.new out, with_error: err
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
