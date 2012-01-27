# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_analytics/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Djoga"]
  gem.email         = ["andrew.djoga@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "simple_analytics"
  gem.require_paths = ["lib"]
  gem.version       = SimpleAnalytics::VERSION

  gem.add_dependency "json"
  gem.add_dependency "google_client_login", "~> 0.3.1"
  gem.add_development_dependency "rspec", "~> 2.8"
  gem.add_development_dependency "fuubar", "~> 0.0.6"
  gem.add_development_dependency "webmock", "~> 1.7.10"
end
