require 'yaml'

namespace :fpm do

  task :init do
    on roles :build do
      require_gem 'fpm'
      path = capture "gem env | sed -n '/^ *- EXECUTABLE DIRECTORY: */ { s/// ; p }'"
      set :gem_path, path
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
        set :version, meta[:version]
      end
    end
  end

  task :cmd_deb do
    run_locally do
      m = fetch(:meta)
      cmd = "-s dir -t deb -n #{fetch(:application)} --prefix=/ "
      unless m.nil?
        cmd << "-v #{m[:version]} "
        cmd << "-a #{m[:arch]} "
        cmd << "--category #{m[:category]} " if m.key?(:category)
        cmd << "--vendor #{m[:vendor]} " if m.key?(:vendor)
        cmd << "--description #{m[:description]} " if m.key?(:description)
        cmd << "--url #{m[:url]} " if m.key?(:url)
        cmd << "--m #{m[:maintainer]} " if m.key?(:maintainer)
        fetch(:deb_dependency).each do |pkg|
          cmd << "-d #{pkg} "
        end
      end
      set :fpm_deb_cmd, cmd
    end
  end

  task :make do
    invoke 'fpm:load_meta'
    invoke 'fpm:cmd_deb'
    on roles :deb do
      within install_path do
        version = fetch(:version)
        cmd = fetch(:fpm_deb_cmd)
        info "fpm #{cmd}"
        file ="#{fetch(:application)}_#{version}_all.deb"
        package_file = deploy_path.join(file)
        if test "[[ -f #{package_file} ]]"
          info "removing existing package #{file}"
          execute :rm, "-f #{package_file}"
        end
        execute "cd #{release_path} && #{fetch(:gem_path)}/fpm #{cmd} -p #{package_file} -- ."
        set :package_file, package_file
      end
    end
  end
end

namespace :parcel do
  before 'parcel:starting', 'fpm:init'
end