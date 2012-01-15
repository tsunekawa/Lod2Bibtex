$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'sinatra'
require './lib/ndl_search'

before do
  @bibtex_path = request.host+(request.port!=80 ? ":#{request.port}":"")+"/bibtex"
end

get '/' do
  erb :index
end
get '/bibtex' do
  content_type 'text/plain'

  ids = Array.new
  ids << params[:id] unless params[:id].nil?
  ids << params[:url].split("/").last unless params[:url].nil?
  
  @items = ids.map {|id| NdlSearch::Item.import(id) }
  erb :bibtex
end
