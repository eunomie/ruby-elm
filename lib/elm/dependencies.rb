require 'contracts'
require 'json'

module Elm
  # When a dependency is not local or file is missing
  class DependencyNotFound
  end

  # Existing dependency file
  class DependencyFound
    include Contracts::Core
    include Contracts::Builtin

    attr_reader :path

    Contract String => DependencyFound
    def initialize(path)
      @path = path

      self
    end

    Contract None => String
    def content
      File.read @path
    end
  end

  # Get files in dependencies from an Elm file or code
  class Dependencies
    include Contracts::Core
    include Contracts::Builtin

    Contract String => ArrayOf[String]
    def self.from_file(file)
      # Error if not exists
      dep = new.init File.read(file), [File.dirname(file)]
      only_existing_files dep.dependencies
    end

    Contract String => ArrayOf[String]
    def self.from_content(content)
      dep = new.init content
      only_existing_files dep.dependencies
    end

    Contract ArrayOf[String] => ArrayOf[String]
    def self.only_existing_files(dependencies)
      dependencies
    end

    Contract String => Elm::Dependencies
    def init(content)
      init content, find_dirs

      self
    end

    # rubocop:disable Lint/DuplicateMethods
    Contract String, ArrayOf[String] => Elm::Dependencies
    def init(content, dirs)
      @content = content
      @dirs = dirs

      self
    end
    # rubocop:enable Lint/DuplicateMethods

    Contract None => ArrayOf[String]
    def dependencies
      extract_dependencies(@content).uniq
    end

    private

    Contract None => Elm::Dependencies
    def initialize
      self
    end

    Contract None => ArrayOf[String]
    def find_dirs
      if File.exist? 'elm-package.json'
        read_elm_package_source_dirs
      else
        ['']
      end
    end

    Contract None => ArrayOf[String]
    def read_elm_package_source_dirs
      config = JSON.parse(File.read('elm-package.json'))
      config['source-directories']
    end

    Contract String => ArrayOf[String]
    def extract_dependencies(src)
      deps = []
      src.each_line do |l|
        next unless l =~ /^import[[:blank:]]+([\w.]+)/
        file = import_to_file Regexp.last_match(1)
        if file.is_a? DependencyFound
          deps << file.path
          deps.concat extract_dependencies(file.content)
        end
      end
      deps
    end

    Contract String => Or[DependencyFound, DependencyNotFound]
    def import_to_file(directive)
      relatives = @dirs.map { |dir| to_relative_file(dir, to_path(directive)) }
      files = relatives.select { |path| File.exist? path }
      if files.empty?
        DependencyNotFound.new
      else
        DependencyFound.new files.first
      end
    end

    Contract String => String
    def to_path(directive)
      directive.tr('.', '/') + '.elm'
    end

    Contract String, String => String
    def to_relative_file(dir, directive)
      File.join(dir, directive).gsub(%r{^/}, '')
    end
  end
end
