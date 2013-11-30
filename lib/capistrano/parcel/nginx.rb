load File.expand_path("../nginx/nginx.rake", __FILE__)

namespace :load do
  task :nginx_defaults do
    load 'capistrano/parcel/nginx/defaults.rb'
  end
end

after 'load:defaults', 'load:nginx_defaults'