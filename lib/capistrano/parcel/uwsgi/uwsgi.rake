require 'erb'

namespace :uwsgi do
  task :init do
    on roles :deb do
      deb_dependency 'uwsgi'
    end
  end

  task :setup do
    # load from local gem
    conf_erb = File.expand_path("../service.conf.erb", __FILE__)
    template = File.read(conf_erb)
    on roles :build do
      config_dir = package_root.join('etc/uwsgi')
      execute :mkdir, '-p', config_dir
      file = config_dir.join("#{fetch(:application)}.uwsgi")
      execute :echo, "\"#{ERB.new(template).result(binding)}\" > #{file}"
      info "written uwsgi config: #{file}"
    end
  end
end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  before 'parcel:starting', 'uwsgi:init'
  after 'parcel:updating', 'uwsgi:setup'
end