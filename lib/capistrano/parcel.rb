load File.expand_path("../parcel/tasks/framework.rake", __FILE__)
load File.expand_path("../parcel/tasks/parcel.rake", __FILE__)
# git extensions
load File.expand_path("../parcel/tasks/git.rake", __FILE__)

require 'capistrano/parcel/paths'