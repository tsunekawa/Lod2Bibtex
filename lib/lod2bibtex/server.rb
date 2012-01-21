#!ruby
# -*- coding:utf-8 -*-

$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'sinatra/base'
require 'yaml'

class Lod2Bibtex::Server < Sinatra::Base
  set :views, File.join(File.expand_path(File.dirname(__FILE__)), %w{ server views })
  set :public_folder, File.join(File.expand_path(File.dirname(__FILE__)), %w{ server public })

  before do
    @bibtex_path = request.host+(request.port!=80 ? ":#{request.port}":"")+"/bibtex"
    @developer = YAML.load_file(env['developer-profile-file'])["developer"] unless env['developer-profile-file'].nil?
    @meta = {
      :author => @developer["name_en"],
      :description => "LODに対応したウェブサービスから書誌情報を取得し、BibTeX形式で出力するウェブサービスです。"
    }
  end

  get '/' do
    erb :index
  end

  get '/bibtex' do
    url = params[:url]

    content_type 'text/plain'
    ::Lod2Bibtex::Resource.new(url).to_bibtex
  end

end
