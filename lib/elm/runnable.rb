require 'contracts'
require 'mkmf'
require 'open3'

module Elm
  # Error raised if executable not found
  class ExecutableNotFoundError < RuntimeError
  end

  # Run command
  class Runnable
    include Contracts::Core
    include Contracts::Builtin

    Contract String => Runnable
    def initialize(command)
      @command = command
      @out = ''
      @err = ''

      unless exists?
        raise ExecutableNotFoundError,
              "Please install executable '#{@command}'"
      end

      self
    end

    Contract None => Bool
    def run
      run []
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract ArrayOf[String] => Bool
    def run(options)
      status = false
      cmd = [@command] + options
      Open3.popen3(*cmd) do |_i, o, e, t|
        @out = o.gets
        @err = e.gets
        status = t.value
      end
      status.success?
    end
    # rubocop:enable Lint/DuplicateMethods

    private

    Contract None => Bool
    def exists?
      !find_executable0(@command).nil?
    end
  end
end
