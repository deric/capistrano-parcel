

namespace :parcel do

  task :starting do
    invoke 'parcel:check'
  end

  desc 'Check required files and directories exist'
  task :check do
    invoke "#{scm}:check"
    invoke 'parcel:check:directories'
  end

  namespace :check do
    desc 'Check shared and release directories exist'
    task :directories do
      on roles :build do
        execute :mkdir, '-pv', shared_path, releases_path
      end
    end
  end

end