require 'elm'

describe Elm::Dependencies do
  before(:each) { create_fixtures_with_dependencies }
  after(:each) { clear_fixtures }

  context '##from_file' do
    it 'should returns the list of files dependencies' do
      expect(Elm::Dependencies.from_file(main_file)).to(
        eq [string_utils_file, case_utils_file])
    end
  end

  context '##from_content' do
    context 'with a elm-package.json file' do
      before(:each) { create_elm_package_file }

      it 'should returns the list of files dependencies' do
        expect(Elm::Dependencies.from_content(File.read(main_file))).to(
          eq [string_utils_file, case_utils_file])
      end
    end

    context 'without elm-package.json file' do
      it 'should returns an empty list' do
        expect(Elm::Dependencies.from_content(File.read(main_file))).to eq []
      end

      context 'in the source folder' do
        it 'should returns the list of files dependencies' do
          content = File.read(main_file)
          Dir.chdir 'fixtures'
          expect(Elm::Dependencies.from_content(content)).to(
            eq ['StringUtils.elm', 'Str/CaseUtils.elm'])
        end
      end
    end
  end
end
