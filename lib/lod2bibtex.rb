#!ruby
# -*- coding:utf-8 -*-

$:.unshift File.expand_path(File.dirname(__FILE__))

module Lod2Bibtex
  autoload :Resource, "lod2bibtex/resource"
  autoload :Server, "lod2bibtex/server"
  autoload :Extractor, "lod2bibtex/extractor"
end
