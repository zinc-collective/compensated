lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "compensated/version"

Gem::Specification.new do |spec|
  spec.name = "compensated"
  spec.version = Compensated::VERSION
  spec.authors = ["Zee"]
  spec.email = ["zee@zinc.coop"]

  spec.summary = "Provide value (In Ruby!). Get paid."
  spec.description = "Compensated makes handling transactions slightly less of a nightmare."
  spec.homepage = "https://github.com/zinc-collective/compensated"
  spec.license = "The Prosperity Public License"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/zinc-collective/compensated"
    spec.metadata["changelog_uri"] = "https://github.com/zinc-collective/compensated/primary/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin|examples)/}) }
  end
  spec.bindir = "exe"
  spec.executables << "compensated"
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "pry"
end
