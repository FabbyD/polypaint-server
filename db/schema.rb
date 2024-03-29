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

ActiveRecord::Schema.define(version: 20180416162134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "canvas_images", force: :cascade do |t|
    t.integer "pos_x", null: false
    t.integer "pos_y", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.float "width"
    t.float "height"
    t.float "rotation", default: 0.0
    t.string "local_id", null: false
    t.bigint "layer_id", null: false
    t.index ["layer_id"], name: "index_canvas_images_on_layer_id"
    t.index ["user_id"], name: "index_canvas_images_on_user_id"
  end

  create_table "canvases", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "width", default: 550.0
    t.float "height", default: 310.0
    t.boolean "private", default: true
    t.boolean "protected", default: false
    t.string "password_digest", default: ""
    t.string "thumbnail"
    t.bigint "template_id"
    t.datetime "thumbnail_updated_at"
    t.index ["template_id"], name: "index_canvases_on_template_id"
    t.index ["user_id"], name: "index_canvases_on_user_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "canvas_id"
    t.bigint "pixel_canvas_id"
    t.index ["canvas_id"], name: "index_chatrooms_on_canvas_id"
    t.index ["pixel_canvas_id"], name: "index_chatrooms_on_pixel_canvas_id"
  end

  create_table "layers", force: :cascade do |t|
    t.string "uuid", null: false
    t.integer "index", null: false
    t.bigint "canvas_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["canvas_id"], name: "index_layers_on_canvas_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.bigint "chatroom_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "pixel_canvases", force: :cascade do |t|
    t.string "name"
    t.string "thumbnail"
    t.string "url"
    t.bigint "user_id"
    t.boolean "private", default: true
    t.boolean "protected", default: false
    t.string "password_digest"
    t.integer "width", default: 400
    t.integer "height", default: 400
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pixel_canvases_on_user_id"
  end

  create_table "strokes", force: :cascade do |t|
    t.integer "points_x", default: [], null: false, array: true
    t.integer "points_y", default: [], null: false, array: true
    t.string "color", limit: 8, null: false
    t.integer "width", null: false
    t.integer "height", null: false
    t.integer "shape", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stroke_type", default: 0, null: false
    t.string "local_id"
    t.bigint "editor_id"
    t.float "radius_x"
    t.float "radius_y"
    t.bigint "layer_id", null: false
    t.index ["editor_id"], name: "index_strokes_on_editor_id"
    t.index ["layer_id"], name: "index_strokes_on_layer_id"
    t.index ["user_id"], name: "index_strokes_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "url"
    t.bigint "user_id"
    t.boolean "private", default: true
    t.float "width", null: false
    t.float "height", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_templates_on_user_id"
  end

  create_table "textboxes", force: :cascade do |t|
    t.text "content", default: ""
    t.integer "pos_x", null: false
    t.integer "pos_y", null: false
    t.string "local_id", null: false
    t.bigint "editor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "width"
    t.float "height"
    t.string "color", limit: 8
    t.float "font_size"
    t.float "rotation", default: 0.0
    t.bigint "layer_id", null: false
    t.index ["editor_id"], name: "index_textboxes_on_editor_id"
    t.index ["layer_id"], name: "index_textboxes_on_layer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "canvas_images", "layers"
  add_foreign_key "canvas_images", "users"
  add_foreign_key "canvases", "templates"
  add_foreign_key "canvases", "users"
  add_foreign_key "chatrooms", "canvases"
  add_foreign_key "chatrooms", "pixel_canvases"
  add_foreign_key "layers", "canvases"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "pixel_canvases", "users"
  add_foreign_key "strokes", "layers"
  add_foreign_key "strokes", "users"
  add_foreign_key "strokes", "users", column: "editor_id"
  add_foreign_key "templates", "users"
  add_foreign_key "textboxes", "layers"
  add_foreign_key "textboxes", "users", column: "editor_id"
end
