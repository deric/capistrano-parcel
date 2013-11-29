require 'yaml'

namespace :fpm do

  task :init do
    on roles :build do
      require_gem 'fpm'
    end
    # require some version of system ruby
    on roles :deb do
      require_deb 'ruby'
    end
  end

  task :load_meta do
    run_locally do
      yaml = local_dir.join('package.yml')
      if File.exists?(yaml)
        begin
          !!YAML.load_file(yaml)
        rescue Exception => e
          error e.message
        end
        meta = YAML::load_file(yaml)
        debug "#{meta}"
        set :meta, meta
      end
    end
  end

  task :make do
    invoke 'fpm:load_meta'
    on roles :build do
      within install_path do
        version = '0.0.1'
        cmd = "-s dir -t deb -n #{fetch(:application)} --category misc -v #{version}"
        fetch(:deb_dependency).each do |pkg|
          cmd << " -d #{pkg}"
        end
        info "fpm #{cmd}"
        gem_path = capture "gem env | sed -n '/^ *- EXECUTABLE DIRECTORY: */ { s/// ; p }'"
        info capture("which fpm")
        file ="#{fetch(:application)}_#{version}_all.deb"
        package_file = deploy_path.join(file)
        if test "[[ -f #{package_file} ]]"
          execute :rm, "-f #{package_file}"
        end
        execute "cd #{release_path} && #{gem_path}/fpm #{cmd} -p #{package_file} -- ."
        set :package_file, package_file
      end
    end
  end
end

namespace :parcel do
  before 'parcel:starting', 'fpm:init'
end