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

ActiveRecord::Schema[8.0].define(version: 2026_06_07_103515) do
  create_table "deliveries", id: uuid, force: :cascade do |t|
    t.string "message_id", limit: 36, null: false
    t.string "recipient_email", null: false
    t.string "variant"
    t.string "email_message_id"
    t.string "status", default: "pending", null: false
    t.text "error_message"
    t.datetime "sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "variables"
    t.text "cc"
    t.text "bcc"
    t.string "from_email"
    t.string "subject_override"
    t.index ["message_id"], name: "index_deliveries_on_message_id"
  end

  create_table "message_variants", id: uuid, force: :cascade do |t|
    t.string "message_id", limit: 36, null: false
    t.string "variant", null: false
    t.text "subject", null: false
    t.text "html_body", null: false
    t.text "text_body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "variant"], name: "index_message_variants_on_message_id_and_variant", unique: true
    t.index ["message_id"], name: "index_message_variants_on_message_id"
  end

  create_table "messages", id: uuid, force: :cascade do |t|
    t.string "slug", null: false
    t.text "subject", null: false
    t.text "html_body", null: false
    t.text "text_body", null: false
    t.string "sender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_messages_on_slug", unique: true
  end

  create_table "providers", id: uuid, force: :cascade do |t|
    t.string "provider"
    t.text "api_key"
    t.string "sending_domain"
    t.string "sender"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "deliveries", "messages"
  add_foreign_key "message_variants", "messages"
end
