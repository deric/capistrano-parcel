require 'erb'

namespace :parcel do

  task :starting do
    invoke 'parcel:check'
  end

  task :updating => :new_release_path do
    invoke "#{sct}:install"
    invoke 'parcel:symlink:release'
    invoke 'parcel:permissions'
    invoke 'parcel:updating:scripts'
  end

  # change permissions to project files
  task :permissions do
    on roles :build do
      deb_postinst "chown -R #{fetch(:owner)} #{fetch(:install_to)}" unless fetch(:owner).empty?
      deb_postinst "chgrp -R #{fetch(:group)} #{fetch(:install_to)}" unless fetch(:group).empty?
    end
  end

  namespace :updating do
    task :scripts do
      fetch(:control_scripts).each do |script|
        template = File.read(File.expand_path("../../templates/#{script}.erb", __FILE__))
        on roles :deb do
          # upload file contents as stream, '-' is sign for skiping empty lines
          upload! StringIO.new(ERB.new(template, nil, '-').result(binding)), "#{shared_path}/#{script}"
        end
      end
    end
  end

  task :packaging do
    invoke "#{fetch(:builder)}:make"
  end

  task :packaged do
    # download builds
    roles(:deb).each do |server|
      run_locally do
        execute :scp, "-i #{server.ssh_options[:keys].first} #{server.user}@#{server.hostname}:#{fetch(:package_file)} ."
      end
    end
  end

  task :finishing do
  end

  # Check required files and directories exist
  task :check do
    invoke "#{sct}:check"
    invoke 'parcel:check:directories'
    invoke 'parcel:check:dependencies'
    invoke 'parcel:check:gems'
  end

  namespace :symlink do
    #desc 'Symlink release to current'
    task :release do
      on roles :build do
        execute :rm, '-rf', current_path
        execute :ln, '-s', release_path, current_path
      end
    end
  end

  namespace :check do
    #desc 'Check shared and release directories exist'
    task :directories do
      on roles :build do
        execute :mkdir, '-pv', releases_path, shared_path
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