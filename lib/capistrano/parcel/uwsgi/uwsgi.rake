require 'erb'

namespace :uwsgi do
  task :init do
    on roles :deb do
      deb_dependency 'uwsgi'
    end
    on roles :build do
      set :project_dir, "#{install_path}"
    end
  end

  task :setup do
    # load from local gem
    conf_erb = File.expand_path("../app.uwsgi.erb", __FILE__)
    template = File.read(conf_erb)
    on roles :build do
      avail_dir = package_root.join('etc/uwsgi/apps-available')
      enabled_dir = package_root.join('etc/uwsgi/apps-enabled')
      execute :mkdir, '-p', avail_dir, enabled_dir
      file = avail_dir.join("#{fetch(:application)}.ini")
      execute :echo, "\"#{ERB.new(template).result(binding)}\" > #{file}"
      info "written uwsgi config: #{file}"
      execute :ln, '-s', file, enabled_dir.join("#{fetch(:application)}.ini")
    end
  end
end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  after 'parcel:starting', 'uwsgi:init'
  after 'parcel:updating', 'uwsgi:setup'
end