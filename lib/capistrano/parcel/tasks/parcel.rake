
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
    invoke 'parcel:check:gems'
  end

  namespace :check do
    desc 'Check shared and release directories exist'
    task :directories do
      on roles :build do
        execute :mkdir, '-pv', releases_path, package_root
      end
    end

    task :dependencies do
      on roles :deb do
        dep = fetch(:deb_dependencies)
        unless dep.nil?
          dep.each do |dep|
            unless test "dpkg-query -l #{dep} >/dev/null 2>&1"
              execute :sudo, "apt-get install -y #{dep}"
            else
              info "#{dep} already installed"
            end
          end
        end
      end
    end

    task :gems do
      on roles :build do
        dep = fetch(:gem_dependencies)
        unless dep.nil?
          dep.each do |dep|
            unless test "gem list #{dep} >/dev/null 2>&1"
              execute :gem, "install #{dep}"
            end
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