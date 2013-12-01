namespace :python do
  task :init do
    on roles :deb do
      deb_dependency 'python3'
      deb_postinst "if [ -f '#{fetch(:intall_to)}/requirements.txt' ]; then"
      pip = fetch(:python3) ? 'pip-3.2' : 'pip'
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