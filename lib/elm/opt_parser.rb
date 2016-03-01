require 'contracts'
require 'optparse'
require 'elm/options'

module Elm
  # Parse command line options
  class OptParser
    include Contracts::Core
    include Contracts::Builtin

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    Contract [String] => Options
    def self.parse(args)
      options = Options.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: ruby-elm [FILES...] ' \
          '[--output FILE] [--yes] [--report FORMAT] [--warn] [--docs FILE]'

        opts.separator ''
        opts.separator 'Available options:'

        opts.on_tail('-h', '--help',
                     'Show this help text') do
          puts opts
          exit
        end

        opts.on('--output [FILE]',
                'Write result to the given .html or .js FILE.') do |output|
          options.output = output
        end

        opts.on('--yes',
                'Reply \'yes\' to all automated prompts.') do
          options.yes = true
        end

        opts.on('--report [FORMAT]', [:normal, :json],
                'Format of error and warning reports',
                '  (normal or json)') do |format|
          options.report = format
        end

        opts.on('--warn',
                'Report warnings to improve code quality.') do
          options.warn = true
        end

        opts.on('--docs [FILE]',
                'Write documentation to FILE as JSON.') do |doc|
          options.docs = doc
        end

        opts.separator ''
        opts.separator 'Examples:'
      end

      opt_parser.parse! args
      options
    end
  end
end
