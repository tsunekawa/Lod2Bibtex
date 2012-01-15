$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'sinatra'
require './lib/ndl_search'

get '/' do
  "hello"
end
get '/bibtex' do
  content_type 'text/plain'

  id = params[:id]
  @item = NdlSearch::Item.import(id)
  p @item
  erb @item.media_type.to_sym
end
