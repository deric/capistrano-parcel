
namespace :parcel do

  task :starting do
    invoke 'parcel:check'
  end

  task :updating => :new_release_path do
    invoke "#{scm}:install"
    invoke 'parcel:symlink:release'
    invoke 'parcel:updating:permissions'
  end

  namespace :updating do
    task :permissions do
      on roles :build do
        execute :chown, "-R #{fetch(:owner)} #{release_path}"
        execute :chgrp, "-R #{fetch(:group)} #{release_path}"
      end
    end
  end

  task :packaging do
    invoke "#{fetch(:builder)}:make"
  end

  task :packaged do
    # download builds
    roles(:deb).each do |server|
      user = server.properties.user
      run_locally do
        execute :scp, "-i #{server.ssh_options[:keys].first} #{server.user}@#{server.hostname}:#{fetch(:package_file)} ."
      end
    end
  end

  task :finishing do
    #on roles :deb do
    #  meta = YAML::load_file(File.join(install_path, 'package.yml'))
    #  info meta.inspect
    #end
  end

  desc 'Check required files and directories exist'
  task :check do
    invoke "#{scm}:check"
    invoke 'parcel:check:directories'
    invoke 'parcel:check:dependencies'
    invoke 'parcel:check:gems'
  end

  namespace :symlink do
    desc 'Symlink release to current'
    task :release do
      on roles :build do
        execute :rm, '-rf', current_path
        execute :ln, '-s', release_path, current_path
      end
    end
  end

  namespace :check do
    desc 'Check shared and release directories exist'
    task :directories do
      on roles :build do
        execute :mkdir, '-pv', releases_path
      end
    end

    task :dependencies do
      on roles :deb do
        dep = fetch(:required_debs)
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
        dep = fetch(:required_gems)
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