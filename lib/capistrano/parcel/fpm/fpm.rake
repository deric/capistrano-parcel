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
        # we don't have symblize_keys! in here
        meta = meta.inject({}){ |memo,(k,v)| memo[k.to_sym] = v; memo }
        debug "#{meta}"
        set :meta, meta
        if !meta.key?(:version) || meta[:version].nil? || meta[:version].empty?
          error "package.yml must contain version"
        end
        set :version, meta[:version]
      end
    end
  end

  task :cmd_deb do
    run_locally do
      m = fetch(:meta)
      cmd = "-s dir -t deb -n #{fetch(:application)} --prefix=/ "
      unless m.nil?
        cmd << "-v '#{m[:version]}' "
        cmd << "-a '#{m[:arch]}' "
        cmd << "--category #{m[:category]} " if m.key?(:category)
        cmd << "--vendor #{m[:vendor]} " if m.key?(:vendor)
        cmd << "--license #{m[:license]} " if m.key?(:license)
        if m.key?(:description)
          error 'description can not be empty' if m[:description].empty?
          cmd << "--description '#{m[:description]}' "
        end
        cmd << "--url '#{m[:url]}' " if m.key?(:url)
        cmd << "-m '#{m[:maintainer]}' " if m.key?(:maintainer)
        fetch(:deb_dependency).each do |pkg|
          cmd << "-d #{pkg} "
        end
        control = fetch(:control_scripts)
        {
          'preinst' => 'before-install',
          'postinst' => 'after-install',
          'prerm' => 'before-remove',
          'postrm' => 'after-remove',
        }.each do |key, val|
          file = "#{shared_path}/#{key}"
          cmd << "--#{val} #{file} " if control.include?(key)
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
        cmd = fetch(:fpm_deb_cmd)
        info "fpm #{cmd}"
        file ="#{fetch(:application)}_#{fetch(:version)}_all.deb"
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