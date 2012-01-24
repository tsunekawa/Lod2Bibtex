#!ruby
# -*- coding:utf-8 -*-

$:.unshift File.join(File.expand_path(File.dirname(__FILE__)), %w{ ndl_search })

module NdlSearch
  NdlSearch_PATH = "http://iss.ndl.go.jp/api/opensearch"
  autoload :Item,   File.join(File.expand_path(File.dirname(__FILE__)), %w{ ndl_search item })
  autoload :Extractor, File.join(File.expand_path(File.dirname(__FILE__)), %w{ ndl_search extractor })
  autoload :Search, File.join(File.expand_path(File.dirname(__FILE__)), %w{ ndl_search search })
end
