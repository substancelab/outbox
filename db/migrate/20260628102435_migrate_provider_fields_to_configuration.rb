# frozen_string_literal: true

class MigrateProviderFieldsToConfiguration < ActiveRecord::Migration[8.1]
  def up
    add_column :providers, :configuration, :text
    remove_column :providers, :api_key, :text
    remove_column :providers, :api_host, :string
  end

  def down
    irreversible!
  end
end
