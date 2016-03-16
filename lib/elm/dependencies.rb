require 'contracts'

module Elm
  class Dependencies
    include Contracts::Core
    include Contracts::Builtin

    Contract String => ArrayOf[String]
    def self.from_file(file)
      # Error if not exists
      dep = new.init File.read(file), File.dirname(file)
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
      init content, Dir.pwd

      self
    end

    Contract String, String => Elm::Dependencies
    def init(content, dir)
      @content = content
      @dir = dir

      self
    end

    Contract None => ArrayOf[String]
    def dependencies
      extract_dependencies(@content).uniq
    end

    private

    Contract None => Elm::Dependencies
    def initialize()
      self
    end

    Contract String => ArrayOf[String]
    def extract_dependencies(src)
      deps = []
      src.each_line do |l|
        if l =~ /^import[[:blank:]]+([\w.]+)/
          dep = dependency_to_filename $1
          if File.exists? dep
            deps << dep
            deps.concat extract_dependencies(File.read(dep))
          end
        end
      end
      deps
    end

    Contract String => String
    def dependency_to_filename(import)
      File.join(@dir, import.gsub('.', '/') + '.elm')
    end
  end
end
