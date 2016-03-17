Feature: Local files dependencies

  `Elm::Dependencies` allows you to extract local dependencies.

  It returns an array containing all local files (using `elm-package.json`
  if needed) used by a specific elm file or content.

  Scenario: No local dependencies
    Given an elm file without local dependencies:
      """elm
      import Html exposing (text)

      main =
        text "Hellow, World!"
      """
    When I run `Elm::Dependencies.from_file` for the file
    Then the dependency array is empty
