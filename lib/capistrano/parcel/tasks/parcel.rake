
namespace :parcel do

  task :starting do
    invoke 'parcel:check'
  end

  task :updating => :new_release_path do
    invoke "#{scm}:create_release"
  end

  desc 'Check required files and directories exist'
  task :check do
    invoke "#{scm}:check"
    invoke 'parcel:check:directories'
    invoke 'parcel:check:dependencies'
  end

  namespace :check do
    desc 'Check shared and release directories exist'
    task :directories do
      on roles :build do
        execute :mkdir, '-pv', releases_path, build_path
      end
    end

    task :dependencies do
      on roles :deb do
        fetch(:deb_dependencies).each do |dep|
          unless test "dpkg-query -l #{dep} >/dev/null 2>&1"
            execute :sudo, "apt-get install -y #{dep}"
          else
            info "#{dep} already installed"
          end
        end
      end
    end
  end

  task :new_release_path do
    set_release_path
  end

  task :last_release_path do
    on roles(:all) do
      last_release = capture(:ls, '-xr', releases_path).split[1]
      set_release_path(last_release)
    end
  end
end