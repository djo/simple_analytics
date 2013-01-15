# -*- encoding: utf-8 -*-
require File.expand_path('../lib/simple_analytics/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Djoga"]
  gem.email         = ["andrew.djoga@gmail.com"]
  gem.description   = %q{The Simple Analytics allows to access Google Analytics report data}
  gem.summary       = %q{Google Analytics Export API Ruby Wrapper}
  gem.homepage      = "https://github.com/Djo/simple_analytics"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "simple_analytics"
  gem.require_paths = ["lib"]
  gem.version       = SimpleAnalytics::VERSION

  gem.add_dependency "json"
  gem.add_dependency "google_client_login", "~> 0.3"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "fuubar"
  gem.add_development_dependency "webmock"
end
