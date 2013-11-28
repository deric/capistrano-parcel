require 'pathname'
module Capistrano
  module DSL
    def venv_path
      install_path.join(fetch(:venv_name))
    end

    def python_bin
      path = fetch(:python_prefix)
      if path.nil?
        error "python_prefix can't be nil"
      end
      # make it relative to build directory
      path[0] = '' if path.start_with?('/')
      path
    end

    def python_bin_path
      release_path.join(python_bin)
    end
  end
end