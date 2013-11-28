
namespace :fpm do

  task :check do
    on roles :build do
      require_gem 'fpm'
    end
    # require some verion of system ruby
    on roles :deb do
      require_deb 'ruby'
    end
  end
end

namespace :parcel do
  before 'parcel:starting', 'fpm:check'
end