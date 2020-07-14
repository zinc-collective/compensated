# frozen_string_literal: true

require 'optparse'
require 'compensated'

module Compensated
  # Contains the code related to running Compensated from the command line.
  # Note: this module is _not_ included by default when you `require 'compensated'`
  # However, it can be included if necessary via `require 'compensated/cli'
  module CLI
    def self.run(argv)
      options = OptionsParser.new.options(argv)
      Runner.new(options: options, command: ARGV[0]).run
    end

    # Runs the CLI by pulling together the configuration from the compensated.json
    # file as well as ensuring the payment processors are loaded into the execution
    # context.
    class Runner
      attr_accessor :options, :command
      def initialize(options:, command:)
        self.options = options
        self.command = prepare_command(command)
      end

      def run
        require_payment_processors
        command.execute
      end

      private def require_payment_processors
        config[:payment_processors].each do |payment_processor|
          require "compensated/#{payment_processor}"
        end
      end

      private def config
        @config ||= Compensated.json_adapter.parse(File.read(File.absolute_path('compensated.json')))
      end

      private def prepare_command(command_name)
        raise MissingCommandError unless command_name
        return command_name if command_name.respond_to?(:execute)

        case command_name
        when 'apply'
          ApplyCommand.new(options, config)
        else
          raise UnrecognizedCommandError, command_name
        end
      end
    end

    # Raised when no command is passed into the CLI.
    class MissingCommandError < StandardError; end

    # Raised when an unrecognized command is passed into the CLI
    class UnrecognizedCommandError < StandardError; end

    # Pulls the passed in options out of ARGV
    class OptionsParser
      # TODO: There may be some way to shift the responsibility for knowing which options
      #      a particular payment adapter accepts into the paymnent adapters themselves.
      OPTION_DEFINITIONS = [
        {
          options: ['--stripe-secret-key=STRIPE_SECRET_KEY'],
          description: 'Secret key for Stripe. Defaults to the $STRIPE_SECRET_KEY environment variable.',
          parser: ->(options, value, _opts = nil) { options[:stripe_secret_key] = value }
        },
        {
          options: ['--stripe-publishable-key=STRIPE_PUBLISHABLE_KEY'],
          description: 'Publishable key for Stripe. Defaults to the $STRIPE_PUBLISHABLE_KEY environment variable.',
          parser: ->(options, value, _opts = nil) { options[:stripe_publishable_key] = value }
        },
        {
          options: ['-h', '--help'],
          description: 'Prints this help',
          parser: lambda do |_options, _value, opts|
            puts(opts)
            exit
          end
        }
      ].freeze

      def options(argv)
        options = default_options
        OptionParser.new do |opts|
          opts.banner = 'Usage: compensated [options]'
          OPTION_DEFINITIONS.each do |option_definition|
            opts.on(*(option_definition[:options] + [option_definition[:description]])) do |value|
              option_definition[:parser].call(options, value, opts)
            end
          end
        end.parse!(argv)
        options
      end

      private def default_options
        {
          stripe_secret_key: ENV['STRIPE_SECRET_KEY'],
          stripe_publishable_key: ENV['STRIPE_PUBLISHABLE_KEY']
        }
      end
    end
  end
end
