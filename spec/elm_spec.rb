require 'elm'

describe Elm do
  context '##make' do
    it 'should instanciate a Runnable' do
      runnable = class_double(Elm::Runnable)
                 .as_stubbed_const(transfer_nested_constants: true)

      expect(runnable).to receive(:new).with('elm-make')
        .and_return(kind_of(Elm::Runnable))

      # An exception is raised when executable is not found
      begin
        Elm.make
      rescue # rubocop:disable Lint/HandleExceptions
      end
    end
  end

  context '##compiler' do
    it 'should instanciate a Compiler' do
      compiler = class_double(Elm::Compiler)
                 .as_stubbed_const(transfer_nested_constants: true)
      allow(Elm).to receive(:make) { Elm::Runnable.new 'true' }

      expect(compiler).to receive(:with)
        .with(kind_of(Elm::Runnable))
        .and_return(kind_of(Elm::Compiler))

      begin
        Elm.compiler
      rescue # rubocop:disable Lint/HandleExceptions
      end
    end
  end
end
