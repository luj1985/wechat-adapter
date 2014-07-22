# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wechat/adapter/version'

Gem::Specification.new do |spec|
  spec.name          = "wechat-adapter"
  spec.version       = Wechat::Adapter::VERSION
  spec.authors       = ["Lu, Jun"]
  spec.email         = ["luj1985@gmail.com"]
  spec.summary       = "Communicate with Tencent wechat API"
  spec.description   = "Use HTTP protocol to communicate with wechat API"
  spec.homepage      = "http://github.com/luj1985/wechat-adapter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-mocks"
end
