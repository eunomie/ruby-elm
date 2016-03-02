require 'elm'

describe Elm::Make do
  context '::files' do
    it '#to_s' do
      expect(Elm::Make.files(['test.elm']).to_s).to match(/^var Elm/)
    end

    it '#to_file' do
      gen = Elm::Make.files(['test.elm'],
                            with_options: { output: 'generated.js' }).to_file
      expect(File.read(gen)).to match(/^var Elm/)
    end
  end
end
