Gem::Specification.new do |s|
  s.name = 'ruby-elm'
  s.version = '0.6.0'
  s.date = '2016-03-12'
  s.summary = 'Elm ruby wrapper'
  s.description = 'Executable and ruby library to compiler elm files.'
  s.authors = ['Yves Brissaud']
  s.email = 'yves.brissaud@gmail.com'
  all_files = `git ls-files -z`.split("\x0")
  s.files = all_files.grep(%r{^(bin|lib)/})
  s.executables = all_files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.homepage = 'https://github.com/eunomie/ruby-elm'
  s.license = 'MIT'

  s.add_development_dependency 'rspec', '~> 3.3', '>= 3.3.0'
  s.add_development_dependency 'guard', '~> 2.13', '>= 2.13.0'
  s.add_development_dependency 'guard-rspec', '~> 4.6', '>= 4.6.4'
  s.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
  s.add_development_dependency 'cucumber', '~> 2.3', '>= 2.3.2'
  s.add_development_dependency 'guard-cucumber', '~> 2.0'
  s.add_development_dependency 'rake', '~> 10.5'
  s.add_development_dependency 'rubocop', '~> 0.37'
  s.add_dependency 'contracts', '~> 0.13.0'
end
