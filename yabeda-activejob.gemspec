require_relative "lib/yabeda/activejob/version"

Gem::Specification.new do |spec|
  spec.name        = "yabeda-activejob"
  spec.version     = Yabeda::ActiveJob::VERSION
  spec.authors     = ["Fullscript"]
  spec.email       = ["josh.etsenake@fullscript.com"]
  spec.summary       = "Extensible Prometheus exporter for monitoring your activejobs"
  spec.description   = "Prometheus exporter for collecting metrics around your activejobs"
  spec.homepage      = "https://github.com/Fullscript/yabeda-activejob"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # TODO
  # i think all the notifications we're hooking into came in 5.2
  # or so but need to confirm that and lower this matches our app for the most part now
  spec.add_dependency "rails", "~> 7.0"
  spec.add_dependency "yabeda", "~> 0.6"

end
