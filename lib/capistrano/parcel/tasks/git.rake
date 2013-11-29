namespace :git do
  # release_path is root of package filesystem
  # desc 'Copy repo to install'
  task install: :'git:update' do
    on roles :build do
      with fetch(:git_environmental_variables) do
        within repo_path do
          execute :mkdir, '-p', install_path
          execute :git, :archive, fetch(:branch), '| tar -x -C', install_path
        end
      end
    end
  end
end