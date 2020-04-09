require 'erb'
module Compensated
  module Spec
    module Helpers

      # @param template_path [String, Path] Absolute path to template file
      # @return PaymentProcessorEventRequest
      def fake_request(template_path, interpolate: {})
        body = template(template_path, interpolate: interpolate)
        PaymentProcessorEventRequest.new(double(form_data?: false, body: body))
      end

      # @param adapter_path [String,Path] Absolute path to adapter directory
      # @param fixture [String] name of fixture file
      # @return Path Absolute path of fixture within the adapter's fixtures directory
      def fixture_path(adapter_path, fixture)
        File.join(adapter_path, "fixtures", fixture)
      end

      # Interpolates data against an ERB template.
      #
      # @param template_path [String, Path] Absolute path to template file
      # @param interpolate: [Hash] Hash with data to interpolate
      # @return [StringIO]
      def template(template_path, interpolate: {})
        return nil if template_path.nil?
        interpolator = Interpolator.new(data: interpolate, template_path: template_path)

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
        ERB.new(template).result(binding)
      end

      # Digs through the data to get a value, falling back to default.
      #
      # @param within [Array<Object>] Keys to dig through to get the value
      # @param default [Object] Default value if key is missing
      # @return [Object], never returns nil, preferring "null"  for JSON compatibility.
      def value(within:, default: nil)
        value = within.reduce(data) do |result, key|
          return default unless result.key?(key)
          result.fetch(key, {})
        end

        value.nil? ? "null" : value
      end

      private def template
        @template = File.open(template_path).read
      end
    end
  end
end