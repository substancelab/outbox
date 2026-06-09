# frozen_string_literal: true

class AddWorkspaceToMessagesDeliveriesAndProviders < ActiveRecord::Migration[8.1]
  def change
    add_column :messages, :workspace_id, :string, :limit => 36
    add_column :deliveries, :workspace_id, :string, :limit => 36
    add_column :providers, :workspace_id, :string, :limit => 36

    reversible do |dir|
      dir.up do
        workspace_id = SecureRandom.uuid
        now = Time.current.strftime("%Y-%m-%d %H:%M:%S")
        execute "INSERT INTO workspaces (id, name, created_at, updated_at) VALUES ('#{workspace_id}', 'Default', '#{now}', '#{now}')"
        execute "UPDATE messages SET workspace_id = '#{workspace_id}'"
        execute "UPDATE deliveries SET workspace_id = '#{workspace_id}'"
        execute "UPDATE providers SET workspace_id = '#{workspace_id}'"
      end
    end

    change_column_null :messages, :workspace_id, false
    change_column_null :deliveries, :workspace_id, false
    change_column_null :providers, :workspace_id, false

    add_index :messages, :workspace_id
    add_index :deliveries, :workspace_id
    add_index :providers, :workspace_id

    add_foreign_key :messages, :workspaces
    add_foreign_key :deliveries, :workspaces
    add_foreign_key :providers, :workspaces
  end
end
