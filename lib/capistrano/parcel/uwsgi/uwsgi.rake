require 'erb'

namespace :uwsgi do
  task :init do
    invoke "uwsgi:supervision:#{fetch(:uwsgi_supervision)}"
    on roles :deb do
      deb_dependency 'uwsgi'
      deb_dependency 'uwsgi-plugin-python3' if fetch(:python3)
    end
    on roles :build do
      set :project_dir, "#{install_path}"
    end
  end

  task :setup do
    invoke "uwsgi:setup:#{fetch(:uwsgi_supervision)}"
  end

  namespace :supervision do
    task :runit do
      on roles :deb do
        deb_dependency 'runit'
        set :uwsgi_conf, install_path.join("config/#{fetch(:application)}.ini")
        deb_postinst "chmod +x #{install_to}/run"
      end
    end

    task :init do
      on roles :deb do
        avail_dir = package_root.join('etc/uwsgi/apps-available')
        set :uwsgi_conf, avail_dir.join("#{fetch(:application)}.ini")
        deb_postinst "if [ ! -f '/etc/uwsgi/apps-enabled/#{fetch(:application)}.ini' ]; then"
        deb_postinst "\tln -s /etc/uwsgi/apps-available/#{fetch(:application)}.ini /etc/uwsgi/apps-enabled/#{fetch(:application)}.ini"
        deb_postinst "fi"
      end
    end

    task :supervisor do
      #TODO
    end
  end

  namespace :setup do
    task :runit do
      conf_erb = File.expand_path("../app.uwsgi.erb", __FILE__)
      run = File.expand_path("../run.erb", __FILE__)
      on roles :build do
        conf_dir = install_path.join('config')
        execute :mkdir, '-p', conf_dir
        upload! StringIO.new(ERB.new(File.read(conf_erb), nil, '-').result(binding)), fetch(:uwsgi_conf)
        upload! StringIO.new(ERB.new(File.read(run), nil, '-').result(binding)), "#{install_path}/run"
      end
    end

    task :init do
      # load from local gem
      conf_erb = File.expand_path("../app.uwsgi.erb", __FILE__)
      template = File.read(conf_erb)
      on roles :build do
        avail_dir = package_root.join('etc/uwsgi/apps-available')
        execute :mkdir, '-p', avail_dir
        upload! StringIO.new(ERB.new(template, nil, '-').result(binding)), fetch(:uwsgi_conf)
      end
    end

    task :supervisor do
      #TODO
    end

  end

end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  after 'parcel:starting', 'uwsgi:init'
  after 'parcel:updating', 'uwsgi:setup'
end
