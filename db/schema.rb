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

ActiveRecord::Schema.define(version: 2019_07_02_192655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "remote_id"
    t.string "name"
    t.json "artist_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_artists_on_name", unique: true
    t.index ["remote_id"], name: "index_artists_on_remote_id", unique: true
  end

  create_table "followed_artists", force: :cascade do |t|
    t.integer "user_id"
    t.integer "artist_id"
    t.string "artist_remote_id"
    t.string "artist_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "artist_id"], name: "index_followed_artists_on_user_id_and_artist_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.boolean "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password"
    t.string "remote_id"
    t.json "spotify_hash"
    t.string "region"
    t.boolean "admin", default: false
    t.string "salt"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remote_id"], name: "index_users_on_remote_id", unique: true
  end

end
