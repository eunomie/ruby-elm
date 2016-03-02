require 'elm'

RSpec::Expectations.configuration.warn_about_potential_false_positives = false

describe Elm::Options do
  subject(:sut) { Elm::Options.new }

  context 'when newly created' do
    it 'should have index.html as output' do
      expect(sut.output).to eq 'index.html'
    end

    it 'should not have yes flag' do
      expect(sut.yes).to be false
    end

    it 'should have normal report' do
      expect(sut.report).to be :normal
    end

    it 'should not warn' do
      expect(sut.warn).to be false
    end

    it 'should have nil docs' do
      expect(sut.docs).to be_nil
    end

    it 'should export nothing' do
      expect(sut.to_a).to eq []
    end
  end

  context '#output=' do
    it 'should accept a string' do
      output = 'file.js'
      sut.output = output
      expect(sut.output).to eq output
    end

    it 'should not accept other than string' do
      expect { sut.output = 2 }.to raise_error
      expect { sut.output = [] }.to raise_error
      expect { sut.output = true }.to raise_error
      expect { sut.output = nil }.to raise_error
      expect { sut.output = {} }.to raise_error
    end

    it 'should export' do
      output = 'file.js'
      sut.output = output
      expect(sut.to_a).to eq ['--output', output]
    end
  end

  context '#with_output' do
    it 'should not modify default options' do
      default_output = sut.output
      output = 'file.js'
      opts = sut.with_output output
      expect(sut.output).to eq default_output
      expect(opts.output).to eq output
    end
  end

  context '#yes=' do
    it 'should accept true' do
      sut.yes = true
      expect(sut.yes).to be true
    end

    it 'should accept false' do
      sut.yes = false
      expect(sut.yes).to be false
    end

    it 'should not accept other than bool' do
      expect { sut.yes = 2 }.to raise_error
      expect { sut.yes = [] }.to raise_error
      expect { sut.yes = 'true' }.to raise_error
      expect { sut.yes = nil }.to raise_error
      expect { sut.yes = {} }.to raise_error
    end

    it 'should export true' do
      sut.yes = true
      expect(sut.to_a).to eq ['--yes']
    end

    it 'should not export false' do
      sut.yes = false
      expect(sut.to_a).to eq []
    end
  end

  context '#with_yes' do
    it 'should not modify default options' do
      opts = sut.with_yes
      expect(sut.yes).to be false
      expect(opts.yes).to be true
    end
  end

  context '#report=' do
    it 'should accept :normal' do
      report = :normal
      sut.report = report
      expect(sut.report).to eq report
    end

    it 'should accept :json' do
      report = :json
      sut.report = report
      expect(sut.report).to eq report
    end

    it 'should not accept other symbols' do
      expect { sut.report = :bla }.to raise_error(
        Elm::BadReportFormatError,
        '\'bla\' is not a valid report format')
    end

    it 'should not accept other than symbol' do
      expect { sut.report = 2 }.to raise_error
      expect { sut.report = [] }.to raise_error
      expect { sut.report = true }.to raise_error
      expect { sut.report = nil }.to raise_error
      expect { sut.report = {} }.to raise_error
    end

    it 'should export json' do
      sut.report = :json
      expect(sut.to_a).to eq ['--report', 'json']
    end

    it 'should not export normal' do
      sut.report = :normal
      expect(sut.to_a).to eq []
    end
  end

  context '#with_report' do
    it 'should not modify default options' do
      default_report = sut.report
      report = :json
      opts = sut.with_report report
      expect(sut.report).to be default_report
      expect(opts.report).to be report
    end
  end

  context '#warn=' do
    it 'should accept true' do
      sut.warn = true
      expect(sut.warn).to be true
    end

    it 'should accept false' do
      sut.warn = false
      expect(sut.warn).to be false
    end

    it 'should not accept other than bool' do
      expect { sut.warn = 2 }.to raise_error
      expect { sut.warn = [] }.to raise_error
      expect { sut.warn = 'true' }.to raise_error
      expect { sut.warn = nil }.to raise_error
      expect { sut.warn = {} }.to raise_error
    end

    it 'should export true' do
      sut.warn = true
      expect(sut.to_a).to eq ['--warn']
    end

    it 'should not export false' do
      sut.warn = false
      expect(sut.to_a).to eq []
    end
  end

  context '#with_warn' do
    it 'should not modify default options' do
      opts = sut.with_warn
      expect(sut.warn).to be false
      expect(opts.warn).to be true
    end
  end

  context '#docs=' do
    it 'should accept a string' do
      docs = 'file.js'
      sut.docs = docs
      expect(sut.docs).to eq docs
    end

    it 'should not accept other than string' do
      expect { sut.docs = 2 }.to raise_error
      expect { sut.docs = [] }.to raise_error
      expect { sut.docs = true }.to raise_error
      expect { sut.docs = nil }.to raise_error
      expect { sut.docs = {} }.to raise_error
    end

    it 'should export docs' do
      docs = 'file.js'
      sut.docs = docs
      expect(sut.to_a).to eq ['--docs', docs]
    end
  end

  context '#with_docs' do
    it 'should not modify default options' do
      default_docs = sut.docs
      docs = 'docs.js'
      opts = sut.with_docs docs
      expect(sut.docs).to be default_docs
      expect(opts.docs).to be docs
    end
  end

  context '::with' do
    it 'should do nothing by default' do
      opts = Elm::Options.with
      expect(opts.output).to eq sut.output
      expect(opts.yes).to eq sut.yes
      expect(opts.report).to eq sut.report
      expect(opts.warn).to eq sut.warn
      expect(opts.docs).to eq sut.docs
    end

    it 'should set output' do
      opts = Elm::Options.with output: 'main.js'
      expect(opts.output).to eq 'main.js'
    end

    it 'should set yes' do
      opts = Elm::Options.with yes: true
      expect(opts.yes).to be true
    end

    it 'should set report' do
      opts = Elm::Options.with report: :json
      expect(opts.report).to eq :json
    end

    it 'should set warn' do
      opts = Elm::Options.with warn: true
      expect(opts.warn).to be true
    end

    it 'should set docs' do
      opts = Elm::Options.with docs: 'file.js'
      expect(opts.docs).to eq 'file.js'
    end
  end
end
