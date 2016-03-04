require 'elm/runnable'
require 'elm/files'
require 'elm/compiler'
require 'elm/opt_parser'
require 'elm/options'

# Elm ruby wrapper
module Elm
  def make
    Elm::Runnable.new 'elm-make'
  end

  def compiler
    Elm::Compiler.with make
  end

  module_function :make, :compiler
end
