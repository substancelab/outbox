# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :messages, :id => :uuid do |t|
      t.string :slug, :null => false
      t.text :subject, :null => false
      t.text :html_body, :null => false
      t.text :text_body, :null => false
      t.string :sender

      t.timestamps
    end

    add_index :messages, :slug, :unique => true
  end
end
