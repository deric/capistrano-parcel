desc 'Deploy last version of package to server(s)'
task :deb do
  invoke 'deb:find_package'
  invoke 'deb:upload'
  invoke 'deb:install'
  invoke 'deb:restart'
end

namespace :deb do
  # find last deb release
  task :find_package do
    run_locally do
      package = capture(:ls, '-xr *.deb').split[0]
      set :last_package, package
    end
  end

  task :upload do
    # all servers in given group
    roles(:all).each do |server|
      run_locally do
        cmd = ""
        opts = server.ssh_options
        unless opts.empty?
          cmd << " -i #{opts[:keys].first}"  if opts.key? :keys
          cmd << " -P#{opts[:port]}" if opts.key? :port
        end
        cmd << " #{local_dir}/#{fetch(:last_package)} #{server.user}@#{server.hostname}: "
        execute :scp, cmd
      end
    end
  end

  task :install do
    on roles :all do
      execute :dpkg, "-i #{fetch(:last_package)}"
    end
  end

  task :restart do
    on roles :all do
      if fetch(:restart_service)
        execute :sv, "restart #{fetch(:application)}"
      end
    end
  end
end