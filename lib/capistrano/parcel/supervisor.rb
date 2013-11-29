load File.expand_path("../supervisor/supervisor.rake", __FILE__)

namespace :load do
  task :supervisor_defaults do
    load 'capistrano/parcel/supervisor/defaults.rb'
  end
end

after 'load:defaults', 'load:supervisor_defaults'