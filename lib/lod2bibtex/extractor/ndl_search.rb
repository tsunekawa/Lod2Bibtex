#!ruby
# -*- coding:utf-8 -*-

require "rexml/document"
require "rest-client"

module Lod2Bibtex::Extractor::NdlSearch

  #
  def import(url)
    @source_no = /iss\.ndl\.go\.jp\/books\/([[:alnum:]\-]+)/.match(url)[1]
    @source = source = get_rdf(@source_no)
    @attr_names = [:author,:title,:publisher,:year,:month,:pages,:isbn,:url]
    self
  end

  def get_rdf(source_no)
    source = RestClient.get("http://iss.ndl.go.jp/books/"+source_no+".rdf")
    @source = REXML::Document.new(source)
  end

  def url
    @url ||= @source.elements['//dcndl:BibResource/dcndl:record/@rdf:resource'].to_s
  end

  def description
    @description ||= @source.text('//dcterms:description')
  end

  def material_types
    if @material_types.nil?
      material_types = @source.get_elements('//dcndl:materialType')
      @material_types = material_types.map{|type|
	type.attribute("rdf:resource").to_s.split("/").last.downcase.to_sym
      }
    end
    @material_types
  end

  def title
    @title  ||= @source.text('//dc:title/rdf:Description/rdf:value')
  end

  def author
    @author ||= @source.text('//dc:creator').to_s.gsub(/\s|著|編|訳|翻訳|\[|\]|\//,"")
  end

  def isbn
    @isbn   ||= @source.text('//dcterms:identifier[@rdf:datatype="http://ndl.go.jp/dcndl/terms/ISBN"]')
  end

  def date
    @date   ||= ( @source.text('//dcterms:date') || @source.text('//dcterms:issued') )
  end

  def publisher
    @publisher ||= @source.text('//dcterms:publisher/foaf:Agent/foaf:name')
  end

  def pages
    @pages ||= @source.text('//dcterms:extent').to_s.scan(/(\d+p)/).flatten.first
  end

  def year
    @year ||= self.date.scan(/\d{4}/).first
  end

  def month
    @month ||= ( self.date.scan(/[\.\-]{1}(\d{2})[\.\-]*/).first || [""]).first
  end

  def ndc
    @ndc ||= @source.text('//item/dc:subject[@xsi:type="dcndl:NDC"]')
  end

  def ndlsh
    @ndlsh ||= @source.text('//item/dc:subject[@xsi:type="dcndl:NDLSH"]')
  end

end
