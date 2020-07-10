require 'json'
require 'jsonpath'
require 'compensated'
require "compensated/spec/version"

module Compensated
  module Spec
    class Error < StandardError; end
    module Helpers
      # @param fixture [String] Name of fixture to get the event body for
      # @param overrides [Array<#location,#value>,Array<Hash>] data to replace in fixture. locations should follow JsonPath format
      # @return String
      def compensated_event_body(fixture, overrides: [])
        compensated_fixture_io(fixture, overrides: overrides).read
      end

      # @param fixture [String] Name of fixture to make a fake request for
      # @param overrides [Array<#location,#value>,Array<Hash>] data to replace in fixture. locations should follow JsonPath format
      # @return Compensated::PaymentProcessorEventRequest
      def compensated_fake_request(fixture, overrides: [])
        io = compensated_fixture_io(fixture, overrides: overrides)
        PaymentProcessorEventRequest.new(double(form_data?: false, body: io))
      end

      # @param fixture [String] Name of fixture to get the full path of
      # @return Path Absolute path of fixture within the adapter's fixtures directory
      def compensated_fixture_path(fixture)
        adapter, *fixture = fixture.split('/')
        File.expand_path(File.join(__dir__, 'spec', adapter, "fixtures", fixture))
      end

      # An IO stream of an event fixtures' body
      #
      # @param fixture [String] name of fixture
      # @param overrides: [Array<#location,#value>,Array<Hash>] data to replace in fixture. locations should follow JsonPath format
      # @see https://goessner.net/articles/JsonPath/
      # @return [StringIO]
      def compensated_fixture_io(fixture, overrides: {})
        return nil if fixture.nil?
        interpolator = Interpolator.new(overrides: overrides, template_path: compensated_fixture_path(fixture))

        StringIO.new(interpolator.result)
      end
    end

    # Interpolates data into a template using JsonPath
    class Interpolator
      attr_accessor :overrides, :template_path
      def initialize(overrides:, template_path:)
        @overrides = overrides
        @template_path = template_path
      end

      # @return [String] interpolated result of applying the data to the template
      def result
        interpolated_output
      end

      private def interpolated_output
        overrides.reduce(template) do |result, override|
          JSON.dump(JsonPath.for(result).gsub(override.fetch("location", override[:location])) { override.fetch("value", override[:value]) }.to_hash)
        end
      end

      private def template
        @template = File.open(template_path).read
      end
    end
  end
end