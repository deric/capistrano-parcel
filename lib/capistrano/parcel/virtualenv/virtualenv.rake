
namespace :virtualenv do

  task :check do
    on roles :build do
      require_deb 'python-virtualenv'
      # must be install also on production system
      deb_dependency 'python-virtualenv'
      deb_postinst "virtualenv #{fetch(:install_to)}/#{fetch(:venv_name)}"
      set :venv_path, "#{install_path}/#{fetch(:venv_name)}"
    end
  end

  task :create do
    invoke 'virtualenv:install:python'
    invoke 'virtualenv:install:venv'
    invoke 'virtualenv:install:pip'
  end

  namespace :install do
    task :python do
      #on roles :build do
      #  version = capture :python3, '--version'
      #  set :curr_python_version, version
      #end
      #unless fetch(:curr_python_version).split(' ').last == fetch(:python_version)
      #  invoke 'python:install'
      #end
    end

    task :venv do
      on roles :build do
        # using system python for now
        python_bin = capture 'which python3'
        within install_path do
          venv_msg = capture "virtualenv --python=#{python_bin} #{fetch(:venv_path)}"
          info venv_msg
        end
      end
    end

    task :pip do
      on roles :build do
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
end

namespace :parcel do
  after 'parcel:starting', 'virtualenv:check'
  after 'parcel:packaging', 'virtualenv:create'
end