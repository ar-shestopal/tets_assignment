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

ActiveRecord::Schema.define(version: 20160313210238) do

  create_table "articles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "body",       limit: 255
    t.integer  "user_id",    limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "body",    limit: 255
    t.integer  "user_id",    limit: 4,   null: false
    t.integer  "article_id", limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",               limit: 50,  null: false
    t.string   "email",              limit: 100, null: false
    t.string   "role",               limit: 20,  null: false
    t.string   "encrypted_password", limit: 255, null: false
    t.string   "salt",               limit: 255, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

end
