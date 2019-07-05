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
    end

  # You will want to make a decision about what you want to do in the event
  # that compensated throws an error. At the very least, you will want
  # to send information to your exception tracker.
  rescue Compensated::Error => _
    # If you don't care about particular errors
    # You can return a 200 success.
    #
    # head :ok
    #
    # However, this means you could "miss" events that you really
    # wanted to capture, but didn't notice because they were discarded
    # quietly.

    # If you want to allow the payment processor's default failure handling
    # behavior to execute, you will want to return a 500
    #
    # head :internal_server_error
    #
    # However, you will want to make sure you are rolling back any transactions
    # and/or ensuring you didn't spawn any jobs that would cause a side effect;
    # as the payment processor may retry sending the event.
  end
end