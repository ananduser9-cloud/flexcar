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

ActiveRecord::Schema[8.1].define(version: 2025_12_22_104605) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "applied_promotion_id"
    t.integer "cart_id", null: false
    t.datetime "created_at", null: false
    t.decimal "discount_amount", precision: 10, scale: 2
    t.decimal "final_price", precision: 10, scale: 2
    t.integer "item_id", null: false
    t.decimal "quantity", precision: 10, scale: 2
    t.decimal "unit_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["item_id"], name: "index_cart_items_on_item_id"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "status"
    t.decimal "total_price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.boolean "active"
    t.integer "brand_id", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.decimal "price"
    t.integer "unit_type"
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_items_on_brand_id"
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "promotion_actions", force: :cascade do |t|
    t.integer "action_type"
    t.datetime "created_at", null: false
    t.integer "promotion_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2
    t.index ["promotion_id"], name: "index_promotion_actions_on_promotion_id"
  end

  create_table "promotion_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "min_value", precision: 10, scale: 2
    t.integer "promotion_id", null: false
    t.bigint "reference_id"
    t.integer "rule_type"
    t.datetime "updated_at", null: false
    t.index ["promotion_id"], name: "index_promotion_rules_on_promotion_id"
  end

  create_table "promotions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "ends_at"
    t.string "name"
    t.datetime "starts_at"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "items"
  add_foreign_key "items", "brands"
  add_foreign_key "items", "categories"
  add_foreign_key "promotion_actions", "promotions"
  add_foreign_key "promotion_rules", "promotions"
end
