require 'fileutils'

module ElmFilesHelpers
  def fixtures_path
    'fixtures'
  end

  def clear_fixtures
    FileUtils.rm_rf fixtures_path
    FileUtils.rm_rf elm_package_json
  end

  def create_fixtures_with_dependencies
    FileUtils.mkdir fixtures_path unless Dir.exist? fixtures_path
    write_main_file
    write_string_utils_file
    write_case_utils_file
  end

  def write_main_file
    File.write(main_file, <<MAIN)
import Html exposing (text)
import StringUtils as Utils
import Str.CaseUtils -- only to check if dependency is added only once

main =
  text (Utils.concat_upper_2 "Hello" "World")
MAIN
  end

  def write_string_utils_file
    File.write(string_utils_file, <<SUTILS)
module StringUtils where
import Str.CaseUtils
-- import Plop.Bla -- check single line comment

concat_upper_2 : String -> String -> String
concat_upper_2 str1 str2 = str1 ++ " " ++ (Str.CaseUtils.upper str2)
SUTILS
  end

  def write_case_utils_file
    str_dir = File.join fixtures_path, 'Str'
    FileUtils.mkdir(str_dir) unless Dir.exist? str_dir
    File.write(case_utils_file, <<CASE)
module Str.CaseUtils where
import String exposing (toUpper)
{-import Bla -} -- multiline comment

upper : String -> String
upper str = toUpper str
CASE
  end

  # rubocop:disable Metrics/MethodLength
  def create_elm_package_file
    File.write(elm_package_json, <<ELM)
{
    "version": "1.0.0",
    "summary": "helpful summary of your project, less than 80 characters",
    "repository": "https://github.com/user/project.git",
    "license": "BSD3",
    "source-directories": [
        "fixtures"
    ],
    "exposed-modules": [],
    "dependencies": {
        "elm-lang/core": "3.0.0 <= v < 4.0.0",
        "evancz/elm-html": "4.0.2 <= v < 5.0.0"
    },
    "elm-version": "0.16.0 <= v < 0.17.0"
}
ELM
  end
  # rubocop:enable Metrics/MethodLength

  def main_file
    File.join fixtures_path, 'Main.elm'
  end

  def string_utils_file
    File.join fixtures_path, 'StringUtils.elm'
  end

  def case_utils_file
    File.join fixtures_path, 'Str', 'CaseUtils.elm'
  end

  def elm_package_json
    'elm-package.json'
  end
end
