# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-provisioner-tachyon/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-provisioner-tachyon"
  spec.version       = Vagrant::Provisioner::Tachyon::VERSION
  spec.authors       = ["Evan Phoenix"]
  spec.email         = ["evan@phx.io"]
  spec.description   = %q{A vagrant provisioner for tachyon}
  spec.summary       = %q{A vagrant provisioner for tachyon}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
