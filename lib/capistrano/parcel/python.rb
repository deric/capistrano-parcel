load File.expand_path("../python/python.rake", __FILE__)

namespace :load do
  task :python_defaults do
    load 'capistrano/parcel/python/defaults.rb'
  end
end

after 'load:defaults', 'load:python_defaults'