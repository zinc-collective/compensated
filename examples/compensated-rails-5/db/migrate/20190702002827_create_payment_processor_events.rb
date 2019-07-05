class CreatePaymentProcessorEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_processor_events do |t|
      t.text :raw_body, null: true, default: nil
      t.string :raw_event_type, null: false
      t.string :raw_event_id, null: true, default: nil
      t.string :vendor, null: true, default: :unknown
      t.timestamps
    end
  end
end
