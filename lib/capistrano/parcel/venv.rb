require 'pathname'
module Capistrano
  module DSL
    def venv_path
      install_path.join(fetch(:venv_name))
    end
  end
end