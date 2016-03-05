require 'contracts'
require 'elm/runnable'
require 'elm/files'
require 'elm/compiler'
require 'elm/opt_parser'
require 'elm/options'

# Elm ruby wrapper
module Elm
  include Contracts::Core
  include Contracts::Builtin

  Contract None => Elm::Runnable
  def self.make
    Elm::Runnable.new 'elm-make'
  end

  Contract None => Elm::Compiler
  def self.compiler
    Elm::Compiler.with make
  end
end
