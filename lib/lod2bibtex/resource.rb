#! ruby -Ku
# -*- coding:utf-8 -*-

class Lod2Bibtex::Resource

  #
  def initialize(url)
    @extractor = Lod2Bibtex::Extractor.resolve(url)
    self.extend @extractor
    import(url)
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
