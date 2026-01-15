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

ActiveRecord::Schema[7.0].define(version: 2026_01_15_182324) do
  create_table "accounts", force: :cascade do |t|
    t.string "user_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "theater_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_administrators_on_account_id"
    t.index ["theater_id"], name: "index_administrators_on_theater_id"
  end

  create_table "movies", force: :cascade do |t|
    t.string "title", null: false
    t.string "category", null: false
    t.text "body", null: false
    t.boolean "publish", null: false
    t.date "published_on", null: false
    t.date "ended_on", null: false
    t.integer "screening_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prices", force: :cascade do |t|
    t.string "ticket_type"
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservation_details", force: :cascade do |t|
    t.integer "reservation_id", null: false
    t.integer "seat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price_id", null: false
    t.index ["price_id"], name: "index_reservation_details_on_price_id"
    t.index ["reservation_id"], name: "index_reservation_details_on_reservation_id"
    t.index ["seat_id"], name: "index_reservation_details_on_seat_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "schedule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_reservations_on_account_id"
    t.index ["schedule_id"], name: "index_reservations_on_schedule_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "movie_id", null: false
    t.integer "screen_id", null: false
    t.datetime "screened_at", null: false
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["movie_id"], name: "index_schedules_on_movie_id"
    t.index ["screen_id"], name: "index_schedules_on_screen_id"
  end

  create_table "screens", force: :cascade do |t|
    t.integer "theater_id", null: false
    t.text "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["theater_id"], name: "index_screens_on_theater_id"
  end

  create_table "seats", force: :cascade do |t|
    t.integer "screen_id", null: false
    t.string "verse", null: false
    t.string "queue", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["screen_id"], name: "index_seats_on_screen_id"
  end

  create_table "theaters", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "administrators", "accounts"
  add_foreign_key "administrators", "theaters"
  add_foreign_key "reservation_details", "prices"
  add_foreign_key "reservation_details", "reservations"
  add_foreign_key "reservation_details", "seats"
  add_foreign_key "reservations", "accounts"
  add_foreign_key "reservations", "schedules"
  add_foreign_key "schedules", "movies"
  add_foreign_key "schedules", "screens"
end
