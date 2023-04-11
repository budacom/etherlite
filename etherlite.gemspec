lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'etherlite/version'

Gem::Specification.new do |spec|
  spec.name          = "etherlite"
  spec.version       = Etherlite::VERSION
  spec.authors       = ["Ignacio Baixas"]
  spec.email         = ["ignacio@budacom.com"]

  spec.summary       = 'Ethereum integration for ruby on rails'
  spec.description   = ''
  spec.homepage      = "https://github.com/budacom/etherlite"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "eth", "~> 0.4.4"
  spec.add_dependency 'keccak', '~> 1.3', '>= 1.3.1'
  spec.add_dependency "power-types", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.7.5"
end
