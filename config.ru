$LOAD_PATH << File.expand_path(File.dirname(__FILE__))
require './webapp'
ENV['RACK_ENV'] = 'development'
run Sinatra::Application
