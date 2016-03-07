require 'contracts'
require 'elm'

module Elm
  # Executable to be used in CLI
  class Bin
    include Contracts::Core
    include Contracts::Builtin

    # rubocop:disable Metrics/MethodLength
    Contract ArrayOf[String] => Bool
    def self.exec(argv)
      options = Elm::OptParser.parse argv
      begin
        compile_output = Elm.compiler.files(argv, with_options: options).to_file
      rescue ExecutableNotFoundError => executable_not_found
        $stderr.puts executable_not_found.message
        exit false
      rescue CompilerError => compiler_error
        $stderr.puts compiler_error.message
        exit false
      end
      $stderr.puts compile_output.stderr
      puts compile_output.stdout
      true
    end
    # rubocop:enable Metrics/MethodLength
  end
end
