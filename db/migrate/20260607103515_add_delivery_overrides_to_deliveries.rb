# frozen_string_literal: true

class AddDeliveryOverridesToDeliveries < ActiveRecord::Migration[8.0]
  def change
    add_column :deliveries, :cc, :text
    add_column :deliveries, :bcc, :text
    add_column :deliveries, :from_email, :string
    add_column :deliveries, :subject_override, :string
  end
end
