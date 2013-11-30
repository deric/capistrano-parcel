require 'erb'

namespace :nginx do
  task :init do
    on roles :deb do
      deb_dependency 'nginx-full'
      deb_postinst "if [ ! -f '/etc/nginx/apps-enabled/#{fetch(:application)}' ]; then"
      deb_postinst "\tln -s /etc/nginx/apps-available/#{fetch(:application)} /etc/nginx/apps-enabled/#{fetch(:application)}"
      deb_postinst "fi"
    end
    on roles :build do
      set :project_dir, "#{install_path}"
    end
  end

  task :setup do
    # load from local gem
    conf_erb = File.expand_path("../app.nginx.erb", __FILE__)
    template = File.read(conf_erb)
    on roles :build do
      avail_dir = package_root.join('etc/nginx/sites-available')
      enabled_dir = package_root.join('etc/nginx/sites-enabled')
      execute :mkdir, '-p', avail_dir, enabled_dir
      file = avail_dir.join("#{fetch(:application)}.ini")
      upload! StringIO.new(ERB.new(template, nil, '-').result(binding)), file
    end
  end
end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  after 'parcel:starting', 'nginx:init'
  after 'parcel:updating', 'nginx:setup'
end