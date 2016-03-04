require 'elm'

describe Elm::Compiler do
  context '##with' do
    it 'should return a compiler with a defined runnable' do
      runnable = Elm::Runnable.new 'true'
      compiler = Elm::Compiler.with runnable
      expect(compiler.instance_variable_get(:@make)).to eq runnable
    end
  end

  # rubocop:disable Metrics/LineLength
  context '#files' do
    context 'without options' do
      it 'should instanciate Files with default options with forced yes' do
        runnable = Elm::Runnable.new 'true'
        compiler = Elm::Compiler.with runnable
        files_list = ['test.elm']
        options = Elm::Options.new

        files = compiler.files files_list
        expect(files.instance_variable_get(:@make)).to eq runnable
        expect(files.instance_variable_get(:@files)).to eq files_list
        expect(files.instance_variable_get(:@options).output).to eq options.output
        expect(files.instance_variable_get(:@options).yes).to be true
        expect(files.instance_variable_get(:@options).warn).to eq options.warn
        expect(files.instance_variable_get(:@options).docs).to eq options.docs
        expect(files.instance_variable_get(:@options).report).to eq options.report
      end
    end

    context 'with option object' do
      it 'should instanciate Files with options and forced yes' do
        runnable = Elm::Runnable.new 'true'
        compiler = Elm::Compiler.with runnable
        files_list = ['test.elm']
        options = Elm::Options.new

        files = compiler.files files_list, with_options: options
        expect(files.instance_variable_get(:@make)).to eq runnable
        expect(files.instance_variable_get(:@files)).to eq files_list
        expect(files.instance_variable_get(:@options).output).to eq options.output
        expect(files.instance_variable_get(:@options).yes).to be true
        expect(files.instance_variable_get(:@options).warn).to eq options.warn
        expect(files.instance_variable_get(:@options).docs).to eq options.docs
        expect(files.instance_variable_get(:@options).report).to eq options.report
      end
    end

    context 'with option values' do
      it 'should instanciate Files with options and forced yes' do
        runnable = Elm::Runnable.new 'true'
        compiler = Elm::Compiler.with runnable
        files_list = ['test.elm']

        files = compiler.files files_list, with_options: { output: 'out.js',
                                                           yes: false,
                                                           warn: false,
                                                           docs: 'docs.js',
                                                           report: :json }
        expect(files.instance_variable_get(:@make)).to eq runnable
        expect(files.instance_variable_get(:@files)).to eq files_list
        expect(files.instance_variable_get(:@options).output).to eq 'out.js'
        expect(files.instance_variable_get(:@options).yes).to be true
        expect(files.instance_variable_get(:@options).warn).to be false
        expect(files.instance_variable_get(:@options).docs).to eq 'docs.js'
        expect(files.instance_variable_get(:@options).report).to eq :json
      end
    end
  end
end
