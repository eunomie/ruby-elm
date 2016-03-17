require 'tempfile'

Given(/^an elm file without local dependencies:$/) do |elm|
  @file = Tempfile.new(['elm', '.elm'])
  @file.write elm
end

When(/^I run `Elm::Dependencies\.from_file` for the file$/) do
  @dependencies = Elm::Dependencies.from_file @file.path
end

Then(/^the dependency array is empty$/) do
  expect(@dependencies).to be_empty
end
