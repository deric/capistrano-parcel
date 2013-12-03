namespace :java do

  task :init do
    on roles :deb do
      deb_dependency 'default-jre'
    end
  end

  task :compile do
    on roles :build do
      within install_path do
        execute  "#{fetch(:java_compile_cmd)}"
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