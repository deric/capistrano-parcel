namespace :git do
  # release_path is root of package filesystem
  # desc 'Copy repo to install'
  task install: :'git:update' do
    on roles :build do
      with fetch(:git_environmental_variables) do
        within repo_path do
          execute :mkdir, '-p', install_path
          info "git submodules #{fetch(:git_submodules)}"
          #unless fetch(:git_submodules)
            execute :git, :archive, fetch(:branch), '| tar -x -C', install_path
          #else
            #execute :git, :clone, "-b #{fetch :branch}", '--single-branch', '--recursive', '.', install_path
          #  execute :git, :submodule, "foreach 'cd #{repo_path}/$path && git archive HEAD | tar -x -C #{install_path}/$path'"
          #end
        end
      end
    end
  end
end