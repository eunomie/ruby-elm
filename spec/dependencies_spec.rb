require 'elm'

describe Elm::Dependencies do
  before(:each) { create_fixtures_with_dependencies }
  after(:each) { clear_fixtures }

  context '##from_file' do
    it 'should returns the list of files dependencies' do
      expect(Elm::Dependencies.from_file main_file).to eq [string_utils_file, case_utils_file]
    end
  end
end
