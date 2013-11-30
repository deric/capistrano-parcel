namespace :supervisor do

  task :init do
    on roles :deb do
      deb_dependency 'supervisor'
      deb_postinst "virtualenv /#{fetch(:install_to)}/#{fetch(:venv_name)}"
      deb_postinst "/etc/init.d/supervisor stop"
      deb_postinst "sleep 1"
      deb_postinst "/etc/init.d/supervisor start"
      deb_postinst "supervisorctl start #{fetch(:application)}"

      deb_prerm "supervisorctl stop #{fetch(:application)}"
    end
  end

  task :setup do
    # load from local gem
    conf_erb = File.expand_path("../service.conf.erb", __FILE__)
    template = File.read(conf_erb)
    on roles :build do
      config_dir = package_root.join('etc/supervisor/conf.d')
      execute :mkdir, '-p', config_dir
      file = config_dir.join("#{fetch(:application)}.conf")
      upload! StringIO.new(ERB.new(template, nil, '-').result(binding)), file
      info "written supervisor config: #{file}"
    end
  end
end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  before 'parcel:starting', 'supervisor:init'
  after 'parcel:updating', 'supervisor:setup'
end