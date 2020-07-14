# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require 'compensated/rails'

module Dummy
  # Example application for Spec purposes
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults Rails.version.slice(0, 3)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
