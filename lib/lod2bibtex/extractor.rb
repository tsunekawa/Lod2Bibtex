#!ruby
# -*- coding:utf-8 -*-

class Lod2Bibtex::Extractor
  def self.add_extractor(name,info_h={:regex=>//,:require=>nil})
    @@extractors ||= Array.new
    @@extractors<< {:name=>name.to_sym}.merge(info_h)
  end

  def self.resolve(url)
    extractor = @@extractors.find {|info| info[:regex] =~ url }
    raise LoadError, "#{url}に対応したExtractorが見つかりません" if extractor.nil?

    require File.join(File.expand_path(File.dirname(__FILE__)), ["extractor", extractor[:require] ])
    extractor = self.const_get extractor[:name]
    extractor
  end

  # default extractors
  add_extractor :NdlSearch, {:regex=>/iss\.ndl\.go\.jp/, :require=>"ndl_search"}
end
