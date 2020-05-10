require_relative 'lib/compensated/proxy/version'

Gem::Specification.new do |spec|
  spec.name          = "compensated-proxy"
  spec.version       = Compensated::Proxy::VERSION
  spec.authors       = ["Zinc Collective LLC"]
  spec.email         = ["hello@zinc.coop"]

  spec.summary       = %q{Provide value. Get paid.}
  spec.description   = %q{Forward standardized payment events from Stripe, Apple Pay, etc to your service}
  spec.homepage      = "https://www.zinc.coop/compensated/"
  spec.license = "Prosperity Public License 3.0.0"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zinc-collective/compensated/tree/0.X/compensated-proxy"
  spec.metadata["changelog_uri"] = "https://github.com/zinc-collective/compensated/tree/0.X/compensated-proxy/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
