require 'pathname'
module Capistrano
  module DSL

    def install_to
      fetch(:install_to)
    end

    def install_path
      path = fetch(:install_to)
      # make it relative to build directory
      if path.start_with?('/')
        p = path[1..path.size]
      else
        p = path
      end
      release_path.join(p)
    end

    def package_root
      release_path
    end

    def local_dir
      Pathname.new(Rake.application.original_dir)
    end

    # source code transfer
    def sct
      fetch(:sct)
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

  end
end