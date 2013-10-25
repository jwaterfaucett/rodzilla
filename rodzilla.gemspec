# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rodzilla/version'

Gem::Specification.new do |spec|
  spec.name          = "rodzilla"
  spec.version       = Rodzilla::VERSION::STRING
  spec.authors       = ["John Faucett"]
  spec.email         = ["jwaterfaucett@gmail.com"]
  spec.description   = %q{A Bugzilla ReST API Client}
  spec.summary       = %q{Bugzilla API Client}
  spec.homepage      = "https://github.com/jwaterfaucett/rodzilla"
  spec.license       = "MIT"

  unless ENV['TRAVIS']
    spec.signing_key   = '/Users/john/.gemcert/gem-private_key.pem'
    spec.cert_chain    = ['gem-public_cert.pem']
  end

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.3"
end
