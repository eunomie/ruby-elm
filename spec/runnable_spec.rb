require 'elm'

describe Elm::Runnable do
  context '#initialize' do
    it 'should raise an error if command not exists' do
      command = 'elm-not-exists'
      expect { Elm::Runnable.new(command) }.to(
        raise_error(Elm::ExecutableNotFoundError,
                    "Please install executable '#{command}'"))
    end

    it 'should not raise an error if command exists' do
      command = 'ruby'
      expect { Elm::Runnable.new(command) }.to_not raise_error
    end
  end

  context '#run' do
    it 'should return true if command is ok' do
      cmd = Elm::Runnable.new 'ruby'
      expect(cmd.run(['-v'])).to be true
    end

    it 'should return false if command is ko' do
      cmd = Elm::Runnable.new 'false'
      expect(cmd.run).to be false
    end
  end
end
