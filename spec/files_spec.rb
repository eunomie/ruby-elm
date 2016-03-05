require 'elm'

describe Elm::Files do
  context '#to_file' do
    it 'should call runnable with good params' do
      runnable = Elm::Runnable.new 'echo'
      compiler = Elm::Compiler.with runnable
      files_list = ['test.elm']
      options = Elm::Options.with warn: true,
                                  output: 'out.js'

      files = compiler.files files_list, with_options: options

      files.to_file

      out = runnable.instance_variable_get(:@out)
      expected_output = (files_list + options.with_yes.to_a).join(' ') + "\n"
      expect(out).to eq expected_output
    end

    it 'should raise an error if compiler fail' do
      runnable = Elm::Runnable.new 'false'
      compiler = Elm::Compiler.with runnable
      files_list = ['test.elm']
      files = compiler.files files_list

      expect { files.to_file }.to raise_error Elm::CompilerError
    end
  end

  context '#to_s' do
    it 'should call runnable with good params' do
      runnable = Elm::Runnable.new 'echo'
      compiler = Elm::Compiler.with runnable
      files_list = ['test.elm']
      options = Elm::Options.new

      files = compiler.files files_list, with_options: options

      files.to_s

      out = runnable.instance_variable_get(:@out)
      expect(out).to match(/--output [^ ]+elm[^.]+.js/)
    end

    it 'should raise an error if compiler fail' do
      runnable = Elm::Runnable.new 'false'
      compiler = Elm::Compiler.with runnable
      files_list = ['test.elm']
      files = compiler.files files_list

      expect { files.to_s }.to raise_error Elm::CompilerError
    end
  end
end
