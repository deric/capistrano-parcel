
namespace :virtualenv do

  task :check do
    on roles :build do
      require_deb 'python-virtualenv'
    end
  end
end

namespace :parcel do
  before 'parcel:starting', 'virtualenv:check'
end