namespace :python do
  task :install do
    invoke 'python:download'
    invoke 'python:extract'
    invoke 'python:compile'
  end

  task :download do
    on roles :build do
      within fetch(:tmp_dir) do
        set :python_tar, "Python-#{fetch(:python_version)}.tar.bz2"
        unless test "[[ -f #{fetch(:python_tar)} ]]"
          execute "wget #{fetch(:python_url)}/#{fetch(:python_version)}/#{fetch(:python_tar)}  >/dev/null 2>&1"
        end
      end
    end
  end

  task :extract do
    on roles :build do
      within fetch(:tmp_dir) do
        execute :tar, "-xjf #{fetch(:python_tar)}"
      end
    end
  end

  task :compile do
    on roles :build do
      path = "#{fetch(:tmp_dir)}/Python-#{fetch(:python_version)}"
      execute :mkdir, '-pv', python_bin_path.expand_path
      execute "#{path}/configure --prefix=#{python_bin_path.expand_path}"
      within path do
        execute :make
        execute :make, 'install'
      end
    end
  end
end