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

  spec.add_dependency "keccak", "~> 1.1"
  spec.add_dependency "power-types", "~> 0.4"
  spec.add_dependency "eth", "~> 0.4"
  spec.add_dependency "activesupport", "~> 6.1"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "guard", "~> 2.18"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "webmock", "~> 3.14"
  spec.add_development_dependency "pry", "~> 0.14"
end
