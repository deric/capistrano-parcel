load File.expand_path("../uwsgi/uwsgi.rake", __FILE__)

namespace :load do
  task :uwsgi_defaults do
    load 'capistrano/parcel/uwsgi/defaults.rb'
  end
end

after 'load:defaults', 'load:uwsgi_defaults'