namespace :python do
  task :init do
    on roles :deb do
      deb_dependency 'python3'
      deb_postinst "if [ -f '#{fetch(:install_to)}/requirements.txt' ]; then"
      pip = 'pip'
      if fetch(:python3)
        pip = 'pip-3.2'
        deb_dependency 'python3-pip'
      end
      deb_postinst "\t#{pip} install -r #{fetch(:install_to)}/requirements.txt"
      deb_postinst "fi"
    end
  end

  task :setup do
    #nothing to do
  end
end

# before 'parcel:started' all plugins should
# specify its requiremets
namespace :parcel do
  after 'parcel:starting', 'python:init'
  after 'parcel:updating', 'python:setup'
end