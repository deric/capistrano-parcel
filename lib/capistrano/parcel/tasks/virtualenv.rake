
namespace :virtualenv do

  task :check do
    on roles :build do
      require_deb 'python-virtualenv'
    end
  end

  task :create do
    on roles :build do
      invoke 'virtualenv:install:venv'
      invoke 'virtualenv:install:pip'
    end
  end

  namespace :install do
    task :venv do
      within install_path do
        venv_msg = capture :virtualenv, fetch(:venv_name)
        info venv_msg
      end
    end

    task :pip do
      within install_path do
        req_file = "#{install_path}/#{fetch(:venv_requirements)}"
        cache = "PIP_DOWNLOAD_CACHE=#{fetch(:pip_cache)}"
        pip = venv_path.join('bin/pip')
        if test "[[ -f #{req_file} ]]"
          execute "#{cache} #{pip} install -r #{req_file}"
        else
          info "Requirements file '#{fetch(:venv_requirements)}' does not exist"
        end
      end
    end

  end
end

namespace :parcel do
  before 'parcel:starting', 'virtualenv:check'
  after 'parcel:building', 'virtualenv:create'
end