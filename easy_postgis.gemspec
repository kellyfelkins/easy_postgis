# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'easy_postgis/version'

Gem::Specification.new do |spec|
  spec.name          = "easy_postgis"
  spec.version       = EasyPostgis::VERSION
  spec.authors       = ["Kelly Felkins"]
  spec.email         = ["kelly@restlater.com"]

  spec.summary       = %q{Adds simple distance scopes that utilize PostGIS indexes to your Rails models.}
  spec.homepage      = "https://github.com/kellyfelkins/easy_postgis"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "pg"
  spec.add_dependency "activerecord"
  spec.add_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "atv"
end
