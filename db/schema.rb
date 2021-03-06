# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170309010632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invitations", force: :cascade do |t|
    t.integer  "issuer_id"
    t.integer  "redeemer_id"
    t.string   "code"
    t.string   "email"
    t.datetime "expires_on"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["code"], name: "index_invitations_on_code", using: :btree
    t.index ["issuer_id"], name: "index_invitations_on_issuer_id", using: :btree
    t.index ["redeemer_id"], name: "index_invitations_on_redeemer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "versionista_pages", force: :cascade do |t|
    t.string   "url"
    t.string   "title"
    t.string   "agency"
    t.string   "site"
    t.string   "versionista_url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "versionista_account"
    t.index ["url"], name: "index_versionista_pages_on_url", using: :btree
  end

  create_table "versionista_versions", force: :cascade do |t|
    t.integer  "page_id"
    t.integer  "previous_id"
    t.string   "diff_with_previous_url"
    t.string   "diff_with_first_url"
    t.integer  "diff_length"
    t.string   "diff_hash"
    t.boolean  "relevant",               default: true
    t.string   "versionista_version_id"
    t.jsonb    "current_annotation"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.jsonb    "annotations"
    t.index ["diff_hash"], name: "index_versionista_versions_on_diff_hash", using: :btree
    t.index ["page_id"], name: "index_versionista_versions_on_page_id", using: :btree
    t.index ["previous_id"], name: "index_versionista_versions_on_previous_id", using: :btree
    t.index ["versionista_version_id"], name: "index_versionista_versions_on_versionista_version_id", using: :btree
  end

  add_foreign_key "invitations", "users", column: "issuer_id"
  add_foreign_key "invitations", "users", column: "redeemer_id"
  add_foreign_key "versionista_versions", "versionista_pages", column: "page_id"
end
