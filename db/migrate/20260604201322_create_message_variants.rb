# frozen_string_literal: true

class CreateMessageVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :message_variants do |t|
      t.references :message, :null => false, :foreign_key => true
      t.string :variant, null: false
      t.text :subject, null: false
      t.text :html_body, null: false
      t.text :text_body, null: false

      t.timestamps
    end

    add_index :message_variants, [:message_id, :variant], unique: true
  end
end
