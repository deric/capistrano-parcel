
set :required_gems, []
set :deb_dependency, []

set :git_submodules, false

set :control_scripts, ['postinst', 'postrm', 'preinst', 'prerm']

# package building tool
set :builder, 'fpm'
set :sct, 'git'

set :owner, 'www-data'
set :group, 'www-data'
set :log_dir, '/var/log'

set :restart_service, true