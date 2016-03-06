require 'elm'

describe Elm::CompileOutput do
  context '#output' do
    it 'should return output' do
      output = 'output'
      co = Elm::CompileOutput.new output,
                                  Elm::RunSuccess.new('', with_error: '')
      expect(co.output).to eq output
    end
  end

  context '#run_status' do
    it 'should return run success' do
      run_status = Elm::RunSuccess.new 'out', with_error: 'err'
      co = Elm::CompileOutput.new '', run_status
      expect(co.run_status).to eq run_status
    end
  end

  context '#stdout' do
    it 'should return stdout of run success' do
      stdout = 'stdout'
      co = Elm::CompileOutput.new '',
                                  Elm::RunSuccess.new(stdout, with_error: '')
      expect(co.stdout).to eq stdout
    end
  end

  context '#stderr' do
    it 'should return stderr of run success' do
      stderr = 'stderr'
      co = Elm::CompileOutput.new '',
                                  Elm::RunSuccess.new('', with_error: stderr)
      expect(co.stderr).to eq stderr
    end
  end
end

describe Elm::Files do
  context '#to_file' do
    it 'should call runnable with good params' do
      runnable = Elm::Runnable.new 'echo'
      compiler = Elm::Compiler.with runnable
      files_list = ['test.elm']
      options = Elm::Options.with warn: true,
                                  output: 'out.js'

      files = compiler.files files_list, with_options: options

      compile_output = files.to_file

      expected_output = (files_list + options.with_yes.to_a).join(' ') + "\n"
      expect(compile_output.stdout).to eq expected_output
      expect(compile_output.output).to eq options.output
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

      compile_output = files.to_s

      expect(compile_output.stdout).to match(/--output [^ ]+elm[^.]+.js/)
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
