class CreatePaymentProcessorEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_processor_events do |t|
      t.text :raw_body, null: true, default: nil
      t.string :event_type, null: false
      t.string :payment_processor_event_id, null: true, default: nil
      t.string :payment_processor_name, null: true, default: :unknown
      t.timestamps
    end
  end
end
