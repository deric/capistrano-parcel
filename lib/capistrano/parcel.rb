load File.expand_path("../parcel/tasks/framework.rake", __FILE__)
load File.expand_path("../parcel/tasks/parcel.rake", __FILE__)
# git extensions
load File.expand_path("../parcel/tasks/git.rake", __FILE__)

require 'capistrano/parcel/paths'

namespace :load do
  task :parcel_defaults do
    load 'capistrano/parcel/defaults.rb'
  end
end

after 'load:defaults', 'load:parcel_defaults'