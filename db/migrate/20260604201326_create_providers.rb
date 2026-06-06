# frozen_string_literal: true

class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers, :id => :uuid do |t|
      t.string :provider
      t.text :api_key
      t.string :sending_domain
      t.string :sender

      t.timestamps
    end
  end
end
