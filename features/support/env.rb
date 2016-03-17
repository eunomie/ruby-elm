require 'simplecov'
SimpleCov.start

$LOAD_PATH << File.expand_path('../../lib', File.dirname(__FILE__))
require 'elm'

After do |scenario|
  if scenario == 'No local dependencies'
    @file.close
    @file.unlink
  end
end
