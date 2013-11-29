set :uwsgi_bin, '/usr/bin/uwsgi'
set :uwsgi_user, 'www-data'
set :uwsgi_port, 3000
set :uwsgi_processes, 1
set :uwsgi_enable_threads, false