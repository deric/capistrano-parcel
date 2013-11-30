set :venv_name, 'vp'
set :pip_cache, "#{fetch(:tmp_dir)}/pip-cache/"
set :venv_requirements, 'requirements.txt'
set :python_url, 'http://www.python.org/ftp/python/'
set :python_version, '3.2.3'
set :python_prefix, '/opt/python'
set :python3, true