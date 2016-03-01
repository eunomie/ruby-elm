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
  end
end