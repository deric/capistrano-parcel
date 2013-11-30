
set :required_gems, []
set :deb_dependency, []

set :control_scripts, ['postinst', 'postrm', 'preinst', 'prerm']

# package building tool
set :builder, 'fpm'
set :sct, 'git'

set :owner, 'www-data'
set :group, 'www-data'