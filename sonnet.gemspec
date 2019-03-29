lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "sonnet/version"

Gem::Specification.new do |spec|
  spec.name = "sonnet"
  spec.version = Sonnet::VERSION
  spec.authors = ["Cory Kaufman-Schofield"]
  spec.email = ["cory@corykaufman.com"]

  spec.summary = "Structured logging for Ruby applications"
  spec.description = "Structured logging for Ruby applications"
  spec.homepage = "https://github.com/allspiritseve/sonnet"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.files = `git ls-files -z`.split("\x0")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
end
