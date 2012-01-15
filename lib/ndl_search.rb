#! ruby -Ku
# -*- coding:utf-8 -*-

require "rexml/document"
require "rest-client"

module NdlSearch
  NdlSearch_PATH = "http://iss.ndl.go.jp/api/opensearch"
 
  class Item
    attr_accessor :ndc, :ndlsh
    def Item.openSearch(q={})
      requrl = "#{NdlSearch_PATH}?"
      q.each{|key,value|
        sep = ( requrl =~ /\?/ ) ? "&" : "?" 
        requrl="#{requrl}#{sep}#{key}=#{URI.escape(value)}"
      }
      result = RestClient.get(requrl)
      #return import(REXML::Document.new(result))
      return REXML::Document.new(result)
    end

    #
    #
    #
    def Item.import(source_no)
      source = RestClient.get("http://iss.ndl.go.jp/books/"+source_no+".rdf")
      source = REXML::Document.new(source)
      #require 'pry'
      #binding.pry
      data = {
          :media_type => source.get_elements('//dcndl:materialType').first.attribute("rdf:resource").to_s,
          :title => source.get_elements('//dc:title/rdf:Description/rdf:value').flatten.first.text,
          :author => source.get_elements('//dc:creator').first.text.gsub(/\s|著|編|訳|翻訳/,""),
          :date => source.get_elements('//dcterms:date').first.text,
          :publisher => source.get_elements('//dcterms:publisher/foaf:Agent/foaf:name').first.text,
          :pages => source.get_elements('//dcterms:extent').first.text.scan(/(\d+p)/).flatten.first
      }
      Item.new(data)
    end

    def Item.get(args={})
      raise if args[:isbn10].nil? and args[:isbn13].nil?

      return Item.get_remote(:isbn10=>args[:isbn10],:isbn13=>args[:isbn13])
    end
    def Item.get_remote(args={})

      if args[:isbn13].nil?
	raise
      else
        result = Item.openSearch(:isbn=>args[:isbn13])
      end

      ndc = result.elements['//item/dc:subject[@xsi:type="dcndl:NDC"]']

      ndlsh = result.elements['//item/dc:subject[@xsi:type="dcndl:NDLSH"]']
      unless ndlsh.nil?
	 ndlsh = ndlsh.text
      else
         ndlsh = ""
      end

      return Item.new({:isbn10=>args[:isbn10],:isbn13=>args[:isbn13],:ndc=>ndc,:ndlsh=>ndlsh})
    end

    attr_accessor :title,:author,:date,:year,:media_type,:publisher,:pages
    def initialize(data)
      @media_type = data[:media_type].split("/").last
      @title  = data[:title]
      @author = data[:author]
      @date   = data[:date]
      @year   = data[:date].split(".").first
      @publisher = data[:publisher]
      @pages   = data[:pages]
    end
  end
end
