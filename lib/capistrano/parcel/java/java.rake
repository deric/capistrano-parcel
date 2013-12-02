namespace :java do

  task :init do
    on roles :deb do
      deb_dependency 'default-jre'
    end
  end

  task :compile do
    on roles :build do
      within repo_path do
        execute :mvn, 'install'
      end
    end
  end
end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  after 'parcel:starting', 'java:init'
  after 'parcel:compiling', 'java:compile'
end