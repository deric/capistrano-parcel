desc 'Deploy last version of package to server(s)'
task :deb do
  invoke 'deb:find_package'
  invoke 'deb:upload'
  invoke 'deb:install'
end

namespace :deb do
  task :find_package do
    run_locally do
      package = capture(:ls, '-xr *.deb').split[0]
      puts "package #{package}"
      set :last_package, package
    end
  end

  task :upload do
    # all servers in given group
    roles(:all).each do |server|
      run_locally do
        opts = server.ssh_options
        cmd = ""
        cmd << " -i #{opts[:keys].first}"  if opts.key? :keys
        cmd << " -P#{opts[:port]}" if opts.key? :port
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
end