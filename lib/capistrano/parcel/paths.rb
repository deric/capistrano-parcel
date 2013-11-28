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
  end
end