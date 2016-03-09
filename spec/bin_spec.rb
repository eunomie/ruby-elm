require 'elm'

describe Elm::Bin do
  context '##exec' do
    context 'with echo command' do
      before(:each) do
        allow(Elm).to receive(:make) { Elm::Runnable.new 'echo' }
      end

      it 'should display arguments with --yes in output' do
        argv = %w(first second)
        expected_output = argv.join(' ') + " --yes\n"

        expect { Elm::Bin.exec(argv) }.to output(expected_output).to_stdout
      end
    end

    context 'with a successful command' do
      before(:each) do
        allow(Elm).to receive(:make) { Elm::Runnable.new 'true' }
      end

      it 'should return true' do
        expect(Elm::Bin.exec([])).to be true
      end
    end

    context 'with a failed command' do
      before(:each) do
        allow(Elm).to receive(:make) { Elm::Runnable.new 'false' }
      end

      it 'should return false' do
        success = true
        begin
          Elm::Bin.exec []
        rescue SystemExit => se
          success = se.success?
        end
        expect(success).to be false
      end
    end

    context 'with a unexisting command' do
      before(:each) do
        allow(Elm).to receive(:make) { Elm::Runnable.new 'no_command_' }
      end

      it 'should return false' do
        success = true
        begin
          Elm::Bin.exec []
        rescue SystemExit => se
          success = se.success?
        end
        expect(success).to be false
      end

      it 'should display error message in stderr' do
        expect do
          begin
            Elm::Bin.exec []
          rescue SystemExit # rubocop:disable Lint/HandleExceptions
          end
        end.to output("Please install executable 'no_command_'\n").to_stderr
      end
    end
  end
end
