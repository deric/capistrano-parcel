namespace :rsync do
  task :install do
    on roles :build do
      execute :mkdir, '-p', install_path
    end
    roles(:build).each do |server|
      run_locally do
        cmd = "-av '#{local_dir}'"
        if File.exists?("#{local_dir}/.rsync-ignore")
          cmd << " --exclude-from=.rsync-ignore"
        end
        opts, ssh = server.ssh_options, ''
        unless opts.empty?
          ssh << " -i #{File.expand_path(opts[:keys].first)}"  if opts.key? :keys
          ssh << " -p#{opts[:port]}" if opts.key? :port
          cmd << %Q[ -e "ssh #{ssh}"] unless ssh.empty?
        end
        cmd << " '#{server.user}@#{server.hostname}:#{install_path}'"
        execute :rsync, cmd
      end
    end
  end

  task :check do
  end
end