
set :gem_dependencies, []
set :deb_dependencies, []
set :deb_dependency, []

set :control_scripts, ['postinst', 'postrm', 'preinst', 'prerm']

# package building tool
set :builder, 'fpm'

set :owner, 'www-data'
set :group, 'www-data'