lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "compensated/stripe/version"

Gem::Specification.new do |spec|
  spec.name          = "compensated-stripe"
  spec.version       = Compensated::Stripe::VERSION
  spec.authors       = ["Zee"]
  spec.email         = ["zee@zincma.de"]

  spec.summary       = "Provide value (in Ruby!). Get paid (With Stripe!)."
  spec.description   = "Compensated makes handling payments in your Ruby app slightly less of a nightmare with Stripe!"
  spec.homepage      = "https://github.com/zinc-technology/compensated"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/zinc-technology/compensated"
    spec.metadata["changelog_uri"] = "https://github.com/zinc-technology/compensated/blob/0.X/compensated-ruby-stripe/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
