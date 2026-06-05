# frozen_string_literal: true

class AddVariablesToDeliveries < ActiveRecord::Migration[8.0]
  def change
    add_column :deliveries, :variables, :text
  end
end
