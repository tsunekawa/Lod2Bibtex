#!ruby
# -*- coding:utf-8 -*-

module NdlSearch::Search
  #
  def self.openSearch(q={})
    requrl = "#{NdlSearch_PATH}?"
    q.each{|key,value|
      sep = ( requrl =~ /\?/ ) ? "&" : "?" 
      requrl="#{requrl}#{sep}#{key}=#{URI.escape(value)}"
    }
    result = RestClient.get(requrl)
    return REXML::Document.new(result)
  end
 
end
