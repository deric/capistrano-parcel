namespace :rsync do
  task :install do
    on roles :build do
      execute :mkdir, '-p', install_path
    end
    roles(:build).each do |server|
      run_locally do
        source = local_dir.to_s
        unless source[-1,1] == '/'
          source << '/' # copy directory contents but not the folder
        end
        cmd = "-av --chmod=o-rwx -p '#{local_dir}/'"
        if File.exists?("#{local_dir}/.rsync-ignore")
          cmd << " --exclude-from=.rsync-ignore"
        end
        exclude = fetch(:rsync_exclude)
        if !exclude.nil? && exclude.size > 0
          exclude.each do |ex|
            cmd << " --exclude='#{ex}'"
          end
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
