# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_18_145533) do

  create_table "admin_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "perishable_token"
    t.string "persistence_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "appreciable_users", primary_key: "slug", id: :string, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_appreciable_users_on_email", unique: true
    t.index ["name"], name: "index_appreciable_users_on_name", unique: true
    t.index ["slug"], name: "index_appreciable_users_on_slug", unique: true
  end

  create_table "appreciable_users_appreciations", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "appreciation_uuid", null: false
    t.string "appreciable_user_slug", null: false
    t.index ["appreciable_user_slug", "appreciation_uuid"], name: "appreciable_user_slug_appreciation_uuid"
    t.index ["appreciation_uuid", "appreciable_user_slug"], name: "appreciation_uuid_appreciable_user_slug"
  end

  create_table "appreciations", primary_key: "uuid", id: :string, limit: 36, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "by_slug", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_appreciations_on_uuid", unique: true
  end

  create_table "authorizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.bigint "admin_user_id"
    t.index ["admin_user_id"], name: "index_authorizations_on_admin_user_id"
  end

  create_table "sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  add_foreign_key "appreciable_users_appreciations", "appreciable_users", column: "appreciable_user_slug", primary_key: "slug"
  add_foreign_key "appreciable_users_appreciations", "appreciations", column: "appreciation_uuid", primary_key: "uuid"
end
