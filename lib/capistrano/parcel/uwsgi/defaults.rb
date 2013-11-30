# for determining if uwsgi is loaded
set :use_uwsgi, true
set :uwsgi_bin, '/usr/bin/uwsgi'
set :uwsgi_user, 'www-data'
set :uwsgi_socket, "/run/uwsgi/app/#{fetch(:application)}/socket"
set :uwsgi_processes, 1
set :uwsgi_enable_threads, false
set :uwsgi_file, ''
set :uwsgi_master, true
set :uwsgi_harakiri, 30
set :uwsgi_no_orphans, true
set :uwsgi_vacuum, true
set :python3, true

# either :runit, :init, :supervisor
set :uwsgi_supervision, :runit