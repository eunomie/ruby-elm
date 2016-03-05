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

      expect(runnable.instance_variable_get(:@out)).to eq (files_list + options.with_yes.to_a).join(' ') + "\n"
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

      expect(runnable.instance_variable_get(:@out)).to match(/--output [^ ]+elm[^.]+.js/)
    end
  end

end
