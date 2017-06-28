# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'etherlite/version'

Gem::Specification.new do |spec|
  spec.name          = "etherlite"
  spec.version       = Etherlite::VERSION
  spec.authors       = ["Ignacio Baixas"]
  spec.email         = ["ignacio@surbtc.com"]

  spec.summary       = %q{Ethereum integration for ruby on rails}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/SurBTC/etherlite"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "digest-sha3", "~> 1.1"
  spec.add_dependency "power-types", "~> 0.1"
  spec.add_dependency "eth", "~> 0.4.4"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
end
