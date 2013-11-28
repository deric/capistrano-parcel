
namespace :fpm do

  task :check do
    on roles :build do
      require_gem 'fpm'
    end
    # require some verion of system ruby
    on roles :deb do
      require_deb 'ruby'
    end
  end

  task :make do
    on roles :build do
      within install_path do
        cmd = "-s dir -t deb -n #{fetch(:application)} --category misc"
        info "fpm #{cmd}"
        gem_path = capture "gem env | sed -n '/^ *- EXECUTABLE DIRECTORY: */ { s/// ; p }'"
        info capture("which fpm")
        file ="#{fetch(:application)}_all.deb"
        execute "cd #{release_path} && #{gem_path}/fpm #{cmd} -p #{deploy_path}/#{file} -- ."
        set :package_file, "#{deploy_path}/#{file}"
      end
    end
  end
end

namespace :parcel do
  before 'parcel:starting', 'fpm:check'
end