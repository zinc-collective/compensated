require 'jsonpath'
require 'compensated'
require "compensated/spec/version"

module Compensated
  module Spec
    class Error < StandardError; end
    module Helpers
      def compensated_event_body(fixture, interpolate: {})
        compensated_fixture_io(fixture, interpolate: interpolate).read
      end

      # @param fixture [String, Path] Absolute path to template file
      # @return PaymentProcessorEventRequest
      def compensated_fake_request(fixture, interpolate: {})
        io = compensated_fixture_io(fixture, interpolate: interpolate)
        PaymentProcessorEventRequest.new(double(form_data?: false, body: io))
      end

      # @param fixture [String] name of fixture file
      # @return Path Absolute path of fixture within the adapter's fixtures directory
      def compensated_fixture_path(fixture)
        adapter, *fixture = fixture.split('/')
        File.expand_path(File.join(__dir__, 'spec', adapter, "fixtures", fixture))
      end

      # Returns an IO version of the event fixtures body
      #
      # @param fixture [String] name of fixture
      # @param interpolate: [Hash] Hash with data to interpolate
      # @return [StringIO]
      def compensated_fixture_io(fixture, interpolate: {})
        return nil if fixture.nil?
        interpolator = Interpolator.new(data: interpolate, template_path: compensated_fixture_path(fixture))

        StringIO.new(interpolator.result)
      end
    end

    # Interpolates data against an ERB template
    class Interpolator
      attr_accessor :data, :template_path
      def initialize(data:, template_path:)
        @data = data
        @template_path = template_path
      end

      # @return [String] interpolated result of applying the data to the template
      def result
        JSON.dump(interpolated_output)
      end

      private def interpolated_output
        data.reduce(template) do |result, override|
          JSON.dump(JsonPath.for(result).gsub(override["location"]) { override["value"] }.to_hash)
        end
      end

      private def template
        @template = File.open(template_path).read
      end
    end
  end
end