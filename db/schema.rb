# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_28_110521) do
  create_table "api_keys", id: uuid, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key_digest", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "workspace_id", limit: 36, null: false
    t.index ["key_digest"], name: "index_api_keys_on_key_digest", unique: true
    t.index ["workspace_id"], name: "index_api_keys_on_workspace_id"
  end

  create_table "deliveries", id: uuid, force: :cascade do |t|
    t.text "bcc"
    t.text "cc"
    t.datetime "created_at", null: false
    t.string "email_message_id"
    t.text "error_message"
    t.string "from_email"
    t.string "message_id", limit: 36, null: false
    t.string "recipient_email", null: false
    t.datetime "sent_at"
    t.string "status", default: "pending", null: false
    t.string "subject_override"
    t.datetime "updated_at", null: false
    t.text "variables"
    t.string "variant"
    t.string "workspace_id", limit: 36, null: false
    t.index ["message_id"], name: "index_deliveries_on_message_id"
    t.index ["workspace_id"], name: "index_deliveries_on_workspace_id"
  end

  create_table "message_variants", id: uuid, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "html_body", null: false
    t.string "message_id", limit: 36, null: false
    t.text "subject", null: false
    t.text "text_body", null: false
    t.datetime "updated_at", null: false
    t.string "variant", null: false
    t.index ["message_id", "variant"], name: "index_message_variants_on_message_id_and_variant", unique: true
    t.index ["message_id"], name: "index_message_variants_on_message_id"
  end

  create_table "messages", id: uuid, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "html_body", null: false
    t.string "sender"
    t.string "slug", null: false
    t.text "subject", null: false
    t.text "text_body", null: false
    t.datetime "updated_at", null: false
    t.string "workspace_id", limit: 36, null: false
    t.index ["slug"], name: "index_messages_on_slug", unique: true
    t.index ["workspace_id"], name: "index_messages_on_workspace_id"
  end

  create_table "providers", id: uuid, force: :cascade do |t|
    t.text "configuration"
    t.datetime "created_at", null: false
    t.string "provider"
    t.string "sender"
    t.string "sending_domain"
    t.datetime "updated_at", null: false
    t.string "workspace_id", limit: 36, null: false
    t.index ["workspace_id"], name: "index_providers_on_workspace_id"
  end

  create_table "workspaces", id: uuid, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "api_keys", "workspaces"
  add_foreign_key "deliveries", "messages"
  add_foreign_key "deliveries", "workspaces"
  add_foreign_key "message_variants", "messages"
  add_foreign_key "messages", "workspaces"
  add_foreign_key "providers", "workspaces"
end
