# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'telegram/rabbit/version'

Gem::Specification.new do |spec|
  spec.name          = "telegram-rabbit"
  spec.version       = Telegram::Rabbit::VERSION
  spec.authors       = ["Stanislav E. Govorov"]
  spec.email         = ["govorov.st@gmail.com"]

  spec.summary       = %q{ RabbitMQ wrapper for telegram-bot-ruby }
  spec.license       = "MIT"

  spec.files         = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "telegram-bot-ruby"
  spec.add_runtime_dependency "bunny"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
end
