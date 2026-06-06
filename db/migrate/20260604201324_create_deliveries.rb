# frozen_string_literal: true

class CreateDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :deliveries, :id => :uuid do |t|
      t.references :message, :type => :uuid, :null => false, :foreign_key => true
      t.string :recipient_email, :null => false
      t.string :variant
      t.string :email_message_id
      t.string :status, :null => false, :default => "pending"
      t.text :error_message
      t.datetime :sent_at

      t.timestamps
    end
  end
end
