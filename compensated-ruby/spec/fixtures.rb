require 'erb'
module Compensated
  module Fixtures
    module TemplateHelpers
      def template(adapter, fixture, interpolate: {})
        uninterpolated_body = fixture.nil? ? nil : File.open(File.join(adapter, "fixtures", fixture)).read
        return uninterpolated_body if uninterpolated_body.nil?
        interpolated_body = ERB.new(uninterpolated_body).result_with_hash(interpolate: interpolate)
        StringIO.new(interpolated_body)
      end
    end
  end
end