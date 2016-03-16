require 'fileutils'

module ElmFilesHelpers
  def fixtures_path
    'fixtures'
  end

  def clear_fixtures
    FileUtils.rm_rf fixtures_path
  end

  def create_fixtures_with_dependencies
    FileUtils.mkdir fixtures_path

    File.write(main_file, <<MAIN)
import Html exposing (text)
import StringUtils as Utils

main =
  text (Utils.concat_upper_2 "Hello" "World")
MAIN

    File.write(string_utils_file, <<SUTILS)
module StringUtils where
import Str.CaseUtils

concat_upper_2 : String -> String -> String
concat_upper_2 str1 str2 = str1 ++ " " ++ (Str.CaseUtils.upper str2)
SUTILS

    FileUtils.mkdir(File.join(fixtures_path, 'Str'))
    File.write(case_utils_file, <<CASE)
module Str.CaseUtils where
import String exposing (toUpper)

upper : String -> String
upper str = toUpper str
CASE
  end

  def main_file
    File.join fixtures_path, 'Main.elm'
  end

  def string_utils_file
    File.join fixtures_path, 'StringUtils.elm'
  end

  def case_utils_file
    File.join fixtures_path, 'Str', 'CaseUtils.elm'
  end
end
