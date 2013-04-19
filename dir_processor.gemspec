# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dir_processor/version'

Gem::Specification.new do |spec|
  spec.name          = "dir_processor"
  spec.version       = DirProcessor::VERSION
  spec.authors       = ["Alexander K"]
  spec.email         = ["xpyro@ya.ru"]
  spec.description   = %q{ dsl to define processor for directories/files structure }.strip
  spec.summary       = %q{ dsl to define processor for directories/files structure }.strip
  spec.homepage      = "https://github.com/sowcow/dir_processor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "def_dsl"
end
