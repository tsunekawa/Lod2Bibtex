$LOAD_PATH << File.join(File.expand_path(File.dirname(__FILE__)), %w{ lib })
require 'lod2bibtex'

use Rack::Config do |config|
  config['developer-profile-file'] = File.join(File.expand_path(File.dirname(__FILE__)), %w{ config developer_profile.yml})
end

run Lod2Bibtex::Server
