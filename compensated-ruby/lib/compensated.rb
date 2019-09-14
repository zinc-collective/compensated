require_relative "compensated/version"
require_relative "compensated/payment_processor_event_request_handler"

module Compensated
  class Error < StandardError; end
  class NoParserForEventError < Error; end

  # Collection of parsers useful in the application
  # Plugins like compensated-stripe, compensated-iap-android,
  # compensated-iap-apple, and compensated-gumroad.
  def self.event_parsers
    @event_parsers ||= []
  end

  # A singletonesque JSON parser for use in plugins that need to interact
  # with JSON from IO streams.
  def self.json_adapter
    @json_adapter ||= RewindingJSONAdapter.new
  end

  # Provides an affordance for overriding the built in
  # rewinding JSON parser/dumper in favor of one that's more appropriate for
  # your use case
  def self.json_adapter=(json_adapter)
    @json_adapter = json_adapter
  end

  # By default, we use the JSON standard library provided by Ruby.
  # In cases where the default JSON parser is unacceptable, configure
  # the json engine using `Compensated.json_engine = <Your preferred JSON parser>`
  def self.json_engine
    require "json" unless defined?(@json_engine)
    @json_engine ||= JSON
  end

  def self.json_engine=json_engine
    @json_engine = json_engine
  end

  # Wraps the built in JSON library to support IO streams that may
  # have been read from already, and ensures provided sources are
  # rewound for later consumption
  class RewindingJSONAdapter
    def parse(io_source)
      # We rewind the IO stream so that if something else has already
      # read from the stream we get the whole thing
      io_source.rewind if io_source.respond_to?(:rewind)

      # If the io source responds to read, use the content to parse the json,
      content = io_source.respond_to?(:read) ? io_source.read : io_source
      # We default to symbolizing names so plugins don't need to guess about
      # it.
      object = engine.parse(content, symbolize_names: true)

      # And we rewind it again when we're done so anyone
      # downstream can use the stream
      io_source.rewind if io_source.respond_to?(:rewind)
      object
    end

    def dump(object)
      engine.dump(object)
    end

    # Ensure we use the json engine specified by the consumer
    private def engine
      Compensated.json_engine
    end
  end
end
