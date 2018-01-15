class AddColumnsToCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :calls, :twilio_call_id, :string, null: false, index: true
    add_column :calls, :from, :string
    add_column :calls, :to, :string
    add_column :calls, :voicemail_url, :string
    add_column :calls, :status, :string
    add_column :calls, :duration, :integer
    add_column :calls, :completed_at, :datetime
  end
end
