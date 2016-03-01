require 'elm'

RSpec::Expectations.configuration.warn_about_potential_false_positives = false

describe Elm::OptParser do
  context '##parse' do
    it 'should return a default option object without arguments' do
      default = Elm::Options.new

      opts = Elm::OptParser.parse []
      expect(opts.output).to eq default.output
      expect(opts.yes).to eq default.yes
      expect(opts.report).to eq default.report
      expect(opts.warn).to eq default.warn
      expect(opts.docs).to eq default.docs
    end

    it 'should set yes' do
      default = Elm::Options.new

      opts = Elm::OptParser.parse ['--yes']
      expect(opts.output).to eq default.output
      expect(opts.yes).to be true
      expect(opts.report).to eq default.report
      expect(opts.warn).to eq default.warn
      expect(opts.docs).to eq default.docs
    end

    it 'should set output' do
      default = Elm::Options.new

      opts = Elm::OptParser.parse ['--output', 'out.js']
      expect(opts.output).to eq 'out.js'
      expect(opts.yes).to eq default.yes
      expect(opts.report).to eq default.report
      expect(opts.warn).to eq default.warn
      expect(opts.docs).to eq default.docs
    end

    it 'should set json report' do
      default = Elm::Options.new

      opts = Elm::OptParser.parse ['--report', 'json']
      expect(opts.output).to eq default.output
      expect(opts.yes).to eq default.yes
      expect(opts.report).to eq :json
      expect(opts.warn).to eq default.warn
      expect(opts.docs).to eq default.docs
    end

    it 'should set warn' do
      default = Elm::Options.new

      opts = Elm::OptParser.parse ['--warn']
      expect(opts.output).to eq default.output
      expect(opts.yes).to eq default.yes
      expect(opts.report).to eq default.report
      expect(opts.warn).to be true
      expect(opts.docs).to eq default.docs
    end

    it 'should set docs' do
      default = Elm::Options.new

      opts = Elm::OptParser.parse ['--docs', 'doc']
      expect(opts.output).to eq default.output
      expect(opts.yes).to eq default.yes
      expect(opts.report).to eq default.report
      expect(opts.warn).to eq default.warn
      expect(opts.docs).to eq 'doc'
    end

    it 'should set all' do
      opts = Elm::OptParser.parse [
        '--output', 'index.js', '--yes', '--report', 'json',
        '--warn', '--docs', 'doc']
      expect(opts.output).to eq 'index.js'
      expect(opts.yes).to be true
      expect(opts.report).to eq :json
      expect(opts.warn).to be true
      expect(opts.docs).to eq 'doc'
    end

    it 'should display help' do
      expect do
        begin
          Elm::OptParser.parse ['-h']
        rescue SystemExit
          puts 'exit'
        end
      end.to output(/Usage: ruby-elm/).to_stdout
    end
  end
end
