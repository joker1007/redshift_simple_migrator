# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redshift_simple_migrator/version'

Gem::Specification.new do |spec|
  spec.name          = "redshift_simple_migrator"
  spec.version       = RedshiftSimpleMigrator::VERSION
  spec.authors       = ["joker1007"]
  spec.email         = ["kakyoin.hierophant@gmail.com"]

  spec.summary       = %q{Simple schema migrator for AWS Redshift}
  spec.description   = %q{Simple schema migrator for AWS Redshift}
  spec.homepage      = ""

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "pg", ">= 0.18"
  spec.add_runtime_dependency "activesupport", ">= 3"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "tapp"
  spec.add_development_dependency "tapp-awesome_print"
end
