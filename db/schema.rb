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

ActiveRecord::Schema[7.0].define(version: 2022_12_17_223534) do
  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.boolean "isActive"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "cost"
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_transactions_on_group_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_debts", force: :cascade do |t|
    t.integer "debt"
    t.integer "person_with_id", null: false
    t.integer "person_id", null: false
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_debts_on_group_id"
    t.index ["person_id"], name: "index_user_debts_on_person_id"
    t.index ["person_with_id"], name: "index_user_debts_on_person_with_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "transactions", "groups"
  add_foreign_key "transactions", "users"
  add_foreign_key "user_debts", "groups"
  add_foreign_key "user_debts", "users", column: "person_id"
  add_foreign_key "user_debts", "users", column: "person_with_id"
  add_foreign_key "user_groups", "groups"
  add_foreign_key "user_groups", "users"
end
