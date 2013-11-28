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
      deploy_path.join('package')
    end

    # dependencies for building
    # accepts either String or Array
    def require_gem(gem)
      dep = fetch(:gem_dependencies)
      dep ||= []
      if gem.respond_to?(:each)
        dep += gem
      else
        dep << gem
      end
      set(:gem_dependencies, dep)
    end

    # dependencies for building
    # accepts either String or Array
    def require_deb(pkg)
      dep = fetch(:deb_dependencies)
      dep ||= []
      if pkg.respond_to?(:each)
        dep += pkg
      else
        dep << pkg
      end
      set(:deb_dependencies, dep)
    end

  end
end