require 'pathname'
module Capistrano
  module DSL

    # dependencies for building
    # accepts either String or Array
    def require_deb(pkg)
      dep = fetch(:required_debs)
      dep ||= []
      if pkg.respond_to?(:each)
        dep += pkg
      else
        dep << pkg
      end
      set(:required_debs, dep)
    end

    def deb_dependency(pkg)
      dep = fetch(:deb_dependency)
      dep ||= []
      if pkg.respond_to?(:each)
        dep += pkg
      else
        dep << pkg
      end
      set(:deb_dependency, dep)
    end

    # helper methods for debian package scripts
    # scripts are executed when package is installed/removed
    %w(postinst postrm preinst prerm).each do |meth|
      key = "deb_#{meth}".to_sym
      define_method(key) do |line|
        script = fetch(key)
        script ||= []
        script << line
        set(key, script)
      end
    end
  end
end