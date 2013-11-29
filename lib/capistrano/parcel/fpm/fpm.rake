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

  task :make do
    on roles :build do
      within install_path do
        info "meta file: #{install_path}/package.yml"
        test "[[ -f #{install_path}/package.yml ]]" do
          info "meta file exists"
          meta = YAML::load_file(File.expand_path(install_path, 'package.yml'))
        end
        version = '0.0.1'
        cmd = "-s dir -t deb -n #{fetch(:application)} --category misc -v #{version}"
        fetch(:deb_dependency).each do |pkg|
          cmd << " -d #{pkg}"
        end
        info "fpm #{cmd}"
        gem_path = capture "gem env | sed -n '/^ *- EXECUTABLE DIRECTORY: */ { s/// ; p }'"
        info capture("which fpm")
        file ="#{fetch(:application)}_all.deb"
        test "[[ -f file ]]" do
          execute :rm, file
        end
        execute "cd #{release_path} && #{gem_path}/fpm #{cmd} -p #{deploy_path}/#{file} -- ."
        set :package_file, "#{deploy_path}/#{file}"
      end
    end
  end
end

namespace :parcel do
  before 'parcel:starting', 'fpm:init'
end