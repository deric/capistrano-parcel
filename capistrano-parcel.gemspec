# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/parcel/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-parcel"
  spec.version       = Capistrano::Parcel::VERSION
  spec.authors       = ["Tomas Barton"]
  spec.email         = ["barton.tomas@gmail.com"]
  spec.description   = %q{Simple tool for remote packaging}
  spec.summary       = %q{Parcel should build package on remote server, download to local and then publish}
  spec.homepage      = 'https://github.com/deric/capistrano-parcel'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'mocha'
  spec.add_dependency 'capistrano', '~> 3.1'
end
