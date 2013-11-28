
set :gem_dependencies, []
set :deb_dependencies, []

# TODO: move to a separate file
set :venv_name, 'vp'
set :pip_cache, "#{fetch(:tmp_dir)}/pip-cache/"
set :venv_requirements, 'requirements.txt'