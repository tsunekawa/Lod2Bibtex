#!ruby
# -*- coding:utf-8 -*-

require './lib/ndl_search.rb'
require 'pp'

result = NdlSearch::Item.import("R100000002-I000007650630-00")
pp result
