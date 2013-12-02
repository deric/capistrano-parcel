load File.expand_path("../java/java.rake", __FILE__)

namespace :load do
  task :java_defaults do
    load 'capistrano/parcel/java/defaults.rb'
  end
end

after 'load:defaults', 'load:java_defaults'