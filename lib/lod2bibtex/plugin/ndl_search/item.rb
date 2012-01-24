#! ruby -Ku
# -*- coding:utf-8 -*-

require "rexml/document"
require "rest-client"

class NdlSearch::Item
  include ::NdlSearch::Extractor

  #
  def self.import(source_no)
    self.new.import(source_no)
  end


  #
  def import(source_no)
    @source = source = get_rdf(source_no)
    @attr_names = [:author,:title,:publisher,:year,:month,:pages,:isbn,:url]
    self
  end

  #
  def to_bibtex
    indent = " "*2
    body = @attr_names.map{|name|
      attribute(name, self.send(name))
    }
    type = self.material_types.first
    label = "#{self.author}:#{self.year}"
    body = indent+(body.compact.join(",\n"+indent))
    "@#{type}{#{label}\n#{body}\n}"
  end

  #
  def attribute(name,value)
    if value=="" or value==[] or value.nil? then
      nil
    else
      "#{name}=\"#{value}\""
    end
  end

end
