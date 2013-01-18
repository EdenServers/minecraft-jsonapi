# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minecraft-jsonapi/version'

Gem::Specification.new do |gem|
  gem.name          = "minecraft-jsonapi"
  gem.version       = Minecraft::JSONAPI::VERSION
  gem.authors       = ["Steven Hoffman"]
  gem.email         = ["git@fustrate.com"]
  gem.description   = "A simple Ruby library to interact with a Minecraft server running the JSONAPI mod"
  gem.summary       = "A simple Ruby library to interact with a Minecraft server running the JSONAPI mod"
  gem.homepage      = "http://www.stevenhoffman.me/"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
