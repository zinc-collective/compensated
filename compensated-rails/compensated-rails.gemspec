$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "compensated/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "compensated-rails"
  spec.version     = Compensated::Rails::VERSION
  spec.authors     = ["Zinc Collective LLC"]
  spec.email       = ["hello@zinc.coop"]
  spec.homepage    = "https://github.com/zinc-collective/compensated"
  spec.summary     = "Rails installer for Compensated Ruby. Get paid!"
  spec.description = "Start using Compensated Ruby in your Rails project. Make handling transactions slightly less of a nightmare."
  spec.license     = "The Prosperity Public License"

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

  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0", "< 7.0"
  spec.add_dependency 'compensated', "0.1.0.pre13"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "rspec-rails"
end
