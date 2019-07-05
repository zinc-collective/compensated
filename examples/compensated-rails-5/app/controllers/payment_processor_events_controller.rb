class PaymentProcessorEventsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    # We provide a basic request handler that normalizes the payment processor event data
    # for your convenience.
    handler = Compensated::PaymentProcessorEventRequestHandler.new(request)


    # We strongly encourage keeping payment processor events around
    # for conflict reconciliation, fraud detection, etc.
    #
    event = PaymentProcessorEvent.create(handler.normalized_event_data.slice(:raw_body,
                                                                             :raw_event_type,
                                                                             :raw_event_id,
                                                                             :payment_processor))
    if event.persisted?
      head :ok
    else
      # Some payment processors will retry sending of the event
      # if you tell them things didn't work out right.

      # We encourage you to return a 5XX status code to trigger
      # the retry behavior.
      head :internal_server_error
    rescue Compensated::Error
      # If you don't care about particular errors
      # You can return `ok`.

      # However, this does mean that you could "miss" events that you really
      # wanted to capture, but didn't notice because they were discarded
      # quietly.
      head :ok
    end
  end
end