
namespace :fpm do

  task :check do
    on roles :build do
      unless test "gem list fpm >/dev/null 2>&1"
        execute :gem, 'install fpm'
      end
    end
  end

  after 'parcel:started', 'fpm:check'
end