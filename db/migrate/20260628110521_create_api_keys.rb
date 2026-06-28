# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[8.1]
  def change
    create_table :api_keys, :id => :uuid do |t|
      t.references :workspace, :null => false, :foreign_key => true, :type => :uuid
      t.string :name
      t.string :key_digest, :null => false

      t.timestamps
    end

    add_index :api_keys, :key_digest, :unique => true
  end
end
