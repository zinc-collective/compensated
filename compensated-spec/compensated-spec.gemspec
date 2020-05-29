require_relative 'lib/compensated/spec/version'

Gem::Specification.new do |spec|
  spec.name          = "compensated-spec"
  spec.version       = Compensated::Spec::VERSION
  spec.authors       = ["Zinc Collective LLC"]
  spec.email         = ["hello@zinc.cop"]

  spec.summary       = %q{Fixtures and test helpers for the compensated payment gateway adapter}
  spec.description   = %q{Build your product with confidence by knowing your payment and subscription tooling is rock-solid.}
  spec.homepage      = "https://www.zinc.coop/compensated/"
  spec.license       = "Prosperity Public License 3.0.0"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/zinc-collective/compensated/tree/0.X/compensated-spec"
  spec.metadata["changelog_uri"] = "https://github.com/zinc-collective/compensated/tree/0.X/compensated-spec/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "compensated"
  spec.add_dependency "jsonpath", "~> 1.0"
  spec.add_development_dependency "cucumber", "~> 3.1"
  spec.add_development_dependency "pry"

end
