require 'pathname'
module Capistrano
  module DSL

    def install_to
      path = fetch(:install_to)
      # make it relative to build directory
      path[0] = '' if path.start_with?('/')
      path
    end

    def install_path
      release_path.join(install_to)
    end

    def package_root
      release_path
    end

    # dependencies for building
    # accepts either String or Array
    def require_gem(gem)
      dep = fetch(:required_gems)
      dep ||= []
      if gem.respond_to?(:each)
        dep += gem
      else
        dep << gem
      end
      set(:required_gems, dep)
    end

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

  end
end