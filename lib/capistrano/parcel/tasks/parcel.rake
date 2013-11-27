

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
        execute :mkdir, '-pv', shared_path, releases_path
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
end