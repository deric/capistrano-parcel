require 'pathname'
module Capistrano
  module DSL

    def install_to
      fetch(:build_at)
    end

    def install_path
      Pathname.new(build_at)
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