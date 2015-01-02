# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150102064057) do

  create_table "companies", force: true do |t|
    t.datetime "docs_last_updated_at"
    t.string   "ts_account_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "documents", force: true do |t|
    t.integer  "company_id"
    t.string   "ts_doc_id"
    t.datetime "last_activity_at"
    t.string   "sender_name"
    t.string   "receiver_name"
    t.string   "type"
    t.datetime "issue_date"
    t.string   "status"
    t.decimal  "amount_before_tax"
    t.decimal  "tax"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sent_or_received"
  end

  add_index "documents", ["company_id"], name: "index_documents_on_company_id"

  create_table "users", force: true do |t|
    t.integer  "company_id"
    t.string   "ts_acount_id"
    t.string   "name"
    t.string   "email"
    t.datetime "last_login_at"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id"

end
