load File.expand_path("../virtualenv/python.rake", __FILE__)
load File.expand_path("../virtualenv/virtualenv.rake", __FILE__)
require 'capistrano/parcel/virtualenv/venv'

namespace :load do
  task :virtualenv_defaults do
    load 'capistrano/parcel/virtualenv/defaults.rb'
  end
end

after 'load:defaults', 'load:virtualenv_defaults'