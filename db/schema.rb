# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091221191535) do

  create_table "carreras", :force => true do |t|
    t.integer  "codigo"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "espacios", :force => true do |t|
    t.string   "codigo"
    t.string   "descripcion"
    t.string   "capacidad"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "tipoespacio_id"
  end

  create_table "eventos", :force => true do |t|
    t.datetime "dtstart"
    t.datetime "dtend"
    t.string   "freq"
    t.string   "byday"
    t.string   "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.string   "exdate",      :default => ""
    t.integer  "espacio_id"
    t.string   "rdate",       :default => ""
    t.boolean  "reccurrent"
    t.integer  "materia_id"
    t.datetime "renddate"
  end

  create_table "materias", :force => true do |t|
    t.integer  "codigo"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "codigo_carrera"
    t.integer  "codigo_plan"
    t.integer  "anio"
  end

  create_table "plans", :force => true do |t|
    t.integer  "codigo"
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "codigo_carrera"
  end

  create_table "tipoespacios", :force => true do |t|
    t.string   "nombre"
    t.string   "descripcion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "tipo"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
