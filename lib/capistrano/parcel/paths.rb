require 'pathname'
module Capistrano
  module DSL

    def build_at
      fetch(:build_at)
    end

    def build_path
      Pathname.new(build_at)
    end
  end
end