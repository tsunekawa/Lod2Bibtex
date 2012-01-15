$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require 'sinatra/base'
require './lib/ndl_search'

class NDLSearchApplication < Sinatra::Base
  get '/' do
    "hello"
  end
  get '/bibtex' do
    content_type 'text/plain'

    id = params[:id]
    @item = NdlSearch::Item.import(id)
    erb @item.media_type.to_sym,{'Content-Type' => 'text/plain'}
  end
end
