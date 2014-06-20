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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140520175510) do

  create_table "_DELETE_data_campaign_publishmap", :force => true do |t|
    t.integer "campaign_id", :limit => 8
  end

  add_index "_DELETE_data_campaign_publishmap", ["campaign_id"], :name => "fk_data_campaign_publishmap_1"

  create_table "_DELETE_data_campaign_publishmap_expression", :force => true do |t|
    t.integer "publishmap_id", :limit => 8
    t.enum    "field",         :limit => [:ENTRYWAY_ID, :GATEWAY_ID, :CONTENT_ID, :ENTRYWAY_PROVIDER_ID, :"3RDPARTY_ID", :BROADCAST_ID, :COUNTRY_ID, :GENRE_ID, :LANGUAGE_ID, :RCA_ID, :LISTENER_ANI_CARRIER_ID, :CAMPAIGN_PLAYSLOT, :LISTENER_IS_ANONYMOUS]
    t.enum    "operator",      :limit => [:EQUAL, :NOT_EQUAL, :IN_CSV_LIST, :NOT_IN_CSV_LIST, :IS_EMPTY, :IS_NOT_EMPTY, :IS_TRUE, :IS_FALSE]
    t.string  "value",         :limit => 8192
  end

  add_index "_DELETE_data_campaign_publishmap_expression", ["publishmap_id"], :name => "fk_data_campaign_publishmap_querie_1"

  create_table "activities", :force => true do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "trackable_title"
    t.string   "user_title"
    t.string   "sec_trackable_type"
    t.string   "sec_trackable_title"
  end

  add_index "activities", ["owner_id", "owner_type"], :name => "index_activities_on_owner_id_and_owner_type"
  add_index "activities", ["recipient_id", "recipient_type"], :name => "index_activities_on_recipient_id_and_recipient_type"
  add_index "activities", ["trackable_id", "trackable_type"], :name => "index_activities_on_trackable_id_and_trackable_type"

  create_table "adm_users", :force => true do |t|
    t.string    "web_user",       :limit => 100
    t.integer   "permission_id",  :limit => 8
    t.string    "web_password",   :limit => 32
    t.integer   "group_id",       :limit => 8,   :default => 0,   :null => false
    t.integer   "enable",         :limit => 1,   :default => 1
    t.integer   "deleted",        :limit => 1,   :default => 0
    t.string    "name",           :limit => 100
    t.string    "first_name",                                     :null => false
    t.string    "last_name",                                      :null => false
    t.float     "credit_limit",                  :default => 0.0
    t.datetime  "creation_date"
    t.timestamp "timestamp",                                      :null => false
    t.string    "address"
    t.string    "address_2"
    t.string    "city",           :limit => 100
    t.string    "state",          :limit => 100
    t.string    "country",        :limit => 100
    t.string    "zip",            :limit => 100
    t.string    "email",          :limit => 100
    t.string    "phone_home",     :limit => 50
    t.string    "phone_work",     :limit => 50
    t.string    "phone_mobile",   :limit => 50
    t.string    "gravatar_email", :limit => 250
    t.string    "gravatar_url",   :limit => 250
    t.integer   "parent_userid",  :limit => 8,   :default => 1
  end

  add_index "adm_users", ["web_user"], :name => "i_user"

  create_table "adm_users_permissions2", :force => true do |t|
    t.string  "name",                   :limit => 200,                    :null => false
    t.integer "ui_order"
    t.string  "ui_group",               :limit => 32
    t.boolean "is_root",                               :default => false
    t.boolean "can_view_pin",                          :default => false
    t.boolean "can_view_email",                        :default => false
    t.boolean "can_login_as_service",                  :default => false
    t.boolean "can_manage_users",                      :default => false
    t.boolean "profile_edit",                          :default => false
    t.boolean "can_manage_rate",                       :default => false
    t.boolean "can_manage_services",                   :default => false
    t.boolean "can_manage_checks",                     :default => false
    t.boolean "can_manage_status",                     :default => false
    t.boolean "can_manage_commissions",                :default => false
    t.boolean "can_manage_coupons",                    :default => false
    t.boolean "can_send_email",                        :default => false
    t.boolean "can_view_reports",                      :default => false
    t.boolean "can_email_edit",                        :default => false
    t.boolean "can_edit_pages",                        :default => false
    t.boolean "can_edit_pages_help",                   :default => false
    t.boolean "can_read_help",                         :default => false
    t.boolean "can_write_help",                        :default => false
    t.boolean "can_read_tickets",                      :default => false
    t.boolean "can_read_work",                         :default => false
  end

  create_table "adm_users_session", :id => false, :force => true do |t|
    t.string "target", :limit => 250, :default => "", :null => false
    t.string "name",   :limit => 250, :default => ""
    t.string "value",  :limit => 250, :default => ""
  end

  add_index "adm_users_session", ["target", "name"], :name => "new_index"

  create_table "admin_dnc_list", :force => true do |t|
    t.integer  "listener_id"
    t.string   "phone_number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "admin_setting", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "aggregate_custom", :force => true do |t|
    t.integer  "user_id",         :limit => 8
    t.integer  "removable_id"
    t.string   "removable_type"
    t.boolean  "remove_children",              :default => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  add_index "aggregate_custom", ["removable_id", "removable_type"], :name => "index_aggregate_custom_on_removable_id_and_removable_type"
  add_index "aggregate_custom", ["removable_id"], :name => "index_aggregate_custom_on_removable_id"
  add_index "aggregate_custom", ["removable_type"], :name => "index_aggregate_custom_on_removable_type"
  add_index "aggregate_custom", ["user_id"], :name => "index_aggregate_custom_on_user_id"

  create_table "area_code", :primary_key => "zip", :force => true do |t|
    t.string  "type",        :limit => 8
    t.string  "primarycity", :limit => 27
    t.string  "state",       :limit => 2
    t.string  "county",      :limit => 39
    t.string  "timezone",    :limit => 28
    t.string  "areacodes",   :limit => 39
    t.decimal "latitude",                  :precision => 6, :scale => 2
    t.decimal "longitude",                 :precision => 7, :scale => 2
    t.string  "country",     :limit => 2
  end

  create_table "area_codes", :force => true do |t|
    t.string  "state",                                   :null => false
    t.string  "area_code",                               :null => false
    t.decimal "latitude",  :precision => 7, :scale => 2, :null => false
    t.decimal "longitude", :precision => 6, :scale => 2, :null => false
  end

  create_table "data_campaign", :force => true do |t|
    t.string    "title",                                                      :limit => 200
    t.integer   "advertise_agency_id",                                        :limit => 8
    t.boolean   "is_active",                                                                                                 :default => false
    t.date      "limit_date_start"
    t.date      "limit_date_stop"
    t.float     "limit_budget_limit",                                                                                        :default => 0.0
    t.float     "limit_budget_balance",                                                                                      :default => 100.0
    t.integer   "limit_play_interruption_per_unique_listener_count_limit",                                                   :default => 0
    t.integer   "limit_play_interruption_per_unique_listener_minutes_window",                                                :default => 0
    t.float     "playslot_A_play_interruption_cost_per_play",                                                                :default => 0.0
    t.float     "playslot_A_play_request_cost_per_play",                                                                     :default => 0.0
    t.float     "playslot_A_play_request_cost_per_unique_listener",                                                          :default => 0.0
    t.float     "playslot_B_play_interruption_cost_per_play",                                                                :default => 0.0
    t.float     "playslot_B_play_request_cost_per_play",                                                                     :default => 0.0
    t.float     "playslot_B_play_request_cost_per_unique_listener",                                                          :default => 0.0
    t.float     "playslot_C_play_interruption_cost_per_play",                                                                :default => 0.0
    t.float     "playslot_C_play_request_cost_per_play",                                                                     :default => 0.0
    t.float     "playslot_C_play_request_cost_per_unique_listener",                                                          :default => 0.0
    t.float     "playslot_D_play_interruption_cost_per_play",                                                                :default => 0.0
    t.float     "playslot_D_play_request_cost_per_play",                                                                     :default => 0.0
    t.float     "playslot_D_play_request_cost_per_unique_listener",                                                          :default => 0.0
    t.enum      "playmatrix_sunday_00",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_01",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_02",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_03",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_04",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_05",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_06",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_07",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_08",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_09",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_10",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_11",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_12",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_13",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_14",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_15",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_16",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_17",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_18",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_19",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_20",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_21",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_22",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_sunday_23",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_00",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_01",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_02",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_03",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_04",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_05",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_06",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_07",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_08",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_09",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_10",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_11",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_12",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_13",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_14",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_15",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_16",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_17",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_18",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_19",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_20",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_21",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_22",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_monday_23",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_00",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_01",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_02",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_03",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_04",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_05",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_06",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_07",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_08",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_09",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_10",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_11",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_12",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_13",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_14",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_15",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_16",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_17",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_18",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_19",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_20",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_21",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_22",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_tuesday_23",                                      :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_00",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_01",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_02",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_03",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_04",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_05",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_06",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_07",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_08",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_09",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_10",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_11",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_12",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_13",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_14",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_15",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_16",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_17",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_18",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_19",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_20",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_21",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_22",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_wednesday_23",                                    :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_00",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_01",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_02",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_03",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_04",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_05",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_06",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_07",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_08",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_09",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_10",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_11",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_12",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_13",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_14",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_15",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_16",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_17",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_18",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_19",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_20",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_21",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_22",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_thursday_23",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_00",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_01",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_02",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_03",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_04",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_05",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_06",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_07",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_08",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_09",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_10",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_11",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_12",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_13",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_14",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_15",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_16",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_17",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_18",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_19",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_20",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_21",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_22",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_friday_23",                                       :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_00",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_01",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_02",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_03",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_04",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_05",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_06",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_07",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_08",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_09",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_10",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_11",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_12",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_13",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_14",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_15",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_16",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_17",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_18",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_19",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_20",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_21",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_22",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.enum      "playmatrix_saturday_23",                                     :limit => [:A, :B, :C, :D],                    :default => :A
    t.integer   "advertise_interruption_prompt_id",                           :limit => 8
    t.enum      "advertise_request_type",                                     :limit => [:PROMPT, :SIPTRANSFER],             :default => :PROMPT
    t.integer   "advertise_request_prompt_id",                                :limit => 8
    t.string    "advertise_request_siptransfer_sip_string"
    t.enum      "advertise_request_siptransfer_callid_mode",                  :limit => [:CLEAN, :LISTENERANI, :LISTENERID], :default => :LISTENERID
    t.integer   "advertise_request_siptransfer_preconnect_prompt_id",         :limit => 8
    t.integer   "advertise_request_siptransfer_failconnect_prompt_id",        :limit => 8
    t.boolean   "is_deleted",                                                                                                :default => false
    t.timestamp "date_last_change"
    t.boolean   "allow_listener_preroll_trigger",                                                                            :default => true
    t.boolean   "allow_listener_timeout_trigger",                                                                            :default => true
    t.boolean   "allow_listener_request_trigger",                                                                            :default => true
  end

  add_index "data_campaign", ["advertise_agency_id"], :name => "fk_data_campaign_1"
  add_index "data_campaign", ["is_active"], :name => "dispatcher_1"
  add_index "data_campaign", ["limit_budget_limit", "limit_budget_balance"], :name => "dispatcher_3"
  add_index "data_campaign", ["limit_date_start", "limit_date_stop"], :name => "dispatcher_2"

  create_table "data_campaign_prompt", :force => true do |t|
    t.string    "title",            :limit => 200
    t.integer   "campaign_id",      :limit => 8
    t.integer   "media_kb",                        :default => 0
    t.integer   "media_seconds",                   :default => 0
    t.timestamp "date_last_change"
  end

  create_table "data_campaign_prompt_blob", :force => true do |t|
    t.binary    "binary",      :limit => 2147483647
    t.timestamp "last_change"
  end

  create_table "data_campaign_publishmap_simple", :force => true do |t|
    t.integer "campaign_id", :limit => 8
    t.enum    "type",        :limit => [:ACCEPT, :REJECT]
    t.enum    "field",       :limit => [:ENTRYWAY_ID, :GATEWAY_ID, :CONTENT_ID, :ENTRYWAY_PROVIDER_ID, :"3RDPARTY_ID", :BROADCAST_ID, :COUNTRY_ID, :GENRE_ID, :LANGUAGE_ID, :RCA_ID, :LISTENER_ANI_CARRIER_ID, :CAMPAIGN_PLAYSLOT, :LISTENER_IS_ANONYMOUS]
    t.enum    "operator",    :limit => [:EQUAL, :NOT_EQUAL, :IN_CSV_LIST, :NOT_IN_CSV_LIST, :IS_EMPTY, :IS_NOT_EMPTY, :IS_TRUE, :IS_FALSE]
    t.string  "value",       :limit => 8192
  end

  add_index "data_campaign_publishmap_simple", ["campaign_id"], :name => "campaign"

  create_table "data_content", :force => true do |t|
    t.string    "title",                                        :limit => 200
    t.integer   "broadcast_id",                                 :limit => 8
    t.integer   "country_id",                                   :limit => 8
    t.integer   "language_id",                                  :limit => 8
    t.integer   "genre_id",                                     :limit => 8
    t.string    "media_type",                                   :limit => 16,                              :default => "FFMPEG"
    t.string    "media_url"
    t.string    "metadata_name"
    t.string    "metadata_genre"
    t.string    "metadata_website"
    t.string    "metadata_public",                              :limit => 32
    t.string    "metadata_bitrate",                             :limit => 32
    t.string    "metadata_track_title"
    t.string    "metadata_track_url"
    t.timestamp "metadata_last_check_date"
    t.integer   "metadata_last_check_server_id",                :limit => 8
    t.timestamp "metadata_track_last_check_date"
    t.integer   "metadata_track_last_check_server_id",          :limit => 8
    t.boolean   "advertise_trigger_enable_listenerpreroll",                                                :default => true
    t.boolean   "advertise_trigger_enable_listenertimeout",                                                :default => true
    t.boolean   "advertise_trigger_enable_conferencetiemout",                                              :default => false
    t.boolean   "advertise_trigger_enable_conferenceadreplace",                                            :default => false
    t.boolean   "is_deleted",                                                                              :default => false
    t.boolean   "flag_no_listener_preroll_ad",                                                             :default => false
    t.boolean   "flag_no_listener_timeout_ad",                                                             :default => false
    t.boolean   "flag_no_ad",                                                                              :default => false
    t.timestamp "date_last_change"
    t.enum      "status",                                       :limit => [:down_permanently, :down, :up]
    t.string    "status_message",                               :limit => 512
    t.boolean   "player_cache_on"
    t.datetime  "last_checked"
    t.string    "backup_media_url"
    t.datetime  "state_changed"
  end

  add_index "data_content", ["broadcast_id"], :name => "fk_data_content_1_idx"
  add_index "data_content", ["country_id"], :name => "fk_data_content_1_idx1"
  add_index "data_content", ["genre_id"], :name => "gener_idx"
  add_index "data_content", ["language_id"], :name => "fk_data_content_1_idx2"
  add_index "data_content", ["status"], :name => "status_idx"

  create_table "data_content_media_decode_fail", :force => true do |t|
    t.datetime "date"
    t.integer  "server_id",                :limit => 8
    t.integer  "content_id",               :limit => 8
    t.string   "media_decoder",            :limit => 16
    t.string   "fail_type",                :limit => 16
    t.string   "media_url_at_event"
    t.string   "media_decoder_last_lines"
  end

  add_index "data_content_media_decode_fail", ["content_id"], :name => "content"
  add_index "data_content_media_decode_fail", ["date"], :name => "date"
  add_index "data_content_media_decode_fail", ["fail_type"], :name => "type"
  add_index "data_content_media_decode_fail", ["media_decoder"], :name => "decoder"
  add_index "data_content_media_decode_fail", ["server_id"], :name => "server"

  create_table "data_content_media_fail", :force => true do |t|
    t.timestamp "date"
    t.integer   "server_id",    :limit => 8
    t.integer   "content_id",   :limit => 8
    t.string    "type",         :limit => 32
    t.string    "url_at_event"
  end

  add_index "data_content_media_fail", ["date"], :name => "date"

  create_table "data_entryway", :force => true do |t|
    t.string    "title",                       :limit => 200
    t.string    "did_e164",                    :limit => 32
    t.integer   "gateway_id",                  :limit => 8
    t.integer   "country_id",                  :limit => 8
    t.integer   "3rdparty_id",                 :limit => 8
    t.integer   "entryway_provider",           :limit => 8
    t.boolean   "is_deleted",                                 :default => false
    t.boolean   "is_default",                                 :default => false
    t.boolean   "flag_no_listener_preroll_ad",                :default => false
    t.boolean   "flag_no_listener_timeout_ad",                :default => false
    t.boolean   "flag_no_ad",                                 :default => false
    t.timestamp "date_last_change"
  end

  add_index "data_entryway", ["3rdparty_id"], :name => "fk_data_entryway_1_idx2"
  add_index "data_entryway", ["country_id"], :name => "fk_data_entryway_1_idx3"
  add_index "data_entryway", ["did_e164"], :name => "DID"
  add_index "data_entryway", ["entryway_provider"], :name => "fk_data_entryway_1_idx"
  add_index "data_entryway", ["gateway_id"], :name => "fk_data_entryway_1_idx1"
  add_index "data_entryway", ["gateway_id"], :name => "gateway"
  add_index "data_entryway", ["title"], :name => "title"

  create_table "data_entryway_provider", :force => true do |t|
    t.string "title", :limit => 200
  end

  create_table "data_gateway", :force => true do |t|
    t.string    "title",                             :limit => 200
    t.integer   "country_id",                        :limit => 8
    t.integer   "language_id",                       :limit => 8
    t.integer   "broadcast_id",                      :limit => 8
    t.integer   "rca_id",                            :limit => 8
    t.boolean   "is_deleted",                                                             :default => false
    t.enum      "empty_extension_rule",              :limit => [:ASK_AGAIN, :PLAY_FIRST], :default => :PLAY_FIRST
    t.integer   "empty_extension_threshold_count",   :limit => 1,                         :default => 2
    t.enum      "invalid_extension_rule",            :limit => [:ASK_AGAIN, :PLAY_FIRST], :default => :PLAY_FIRST
    t.integer   "invalid_extension_threshold_count", :limit => 1,                         :default => 3
    t.boolean   "ivr_welcome_enabled",                                                    :default => true
    t.integer   "ivr_welcome_prompt_id",             :limit => 8
    t.integer   "ivr_extension_ask_prompt_id",       :limit => 8
    t.boolean   "ivr_extension_invalid_enabled",                                          :default => true
    t.integer   "ivr_extension_invalid_prompt_id",   :limit => 8
    t.boolean   "flag_no_listener_preroll_ad",                                            :default => false
    t.boolean   "flag_no_listener_timeout_ad",                                            :default => false
    t.boolean   "flag_no_ad",                                                             :default => false
    t.timestamp "date_last_change"
    t.boolean   "flag_broadcaster"
    t.string    "website"
    t.integer   "data_entryway_id"
    t.string    "logo_file_name"
    t.string    "logo_content_type"
    t.integer   "logo_file_size"
    t.datetime  "logo_updated_at"
  end

  add_index "data_gateway", ["broadcast_id"], :name => "fk_data_gateway_3_idx"
  add_index "data_gateway", ["country_id"], :name => "fk_data_gateway_1_idx"
  add_index "data_gateway", ["ivr_extension_ask_prompt_id"], :name => "fk_data_gateway_6"
  add_index "data_gateway", ["ivr_extension_invalid_prompt_id"], :name => "fk_data_gateway_7"
  add_index "data_gateway", ["ivr_welcome_prompt_id"], :name => "fk_data_gateway_5"
  add_index "data_gateway", ["language_id"], :name => "fk_data_gateway_2_idx"
  add_index "data_gateway", ["rca_id"], :name => "fk_data_gateway_4_idx"

  create_table "data_gateway_conference", :force => true do |t|
    t.integer "gateway_id", :limit => 8
    t.integer "content_id", :limit => 8
    t.string  "extension",  :limit => 16
  end

  add_index "data_gateway_conference", ["content_id"], :name => "fk_data_gateway_content_2_idx"
  add_index "data_gateway_conference", ["gateway_id"], :name => "fk_data_gateway_content_1_idx"

  create_table "data_gateway_prompt", :force => true do |t|
    t.string    "title",            :limit => 200
    t.integer   "gateway_id",       :limit => 8
    t.integer   "media_kb",                        :default => 0
    t.integer   "media_seconds",                   :default => 0
    t.timestamp "date_last_change"
  end

  add_index "data_gateway_prompt", ["gateway_id"], :name => "fk_data_gateway_prompt_1"

  create_table "data_gateway_prompt_blob", :force => true do |t|
    t.binary    "binary",      :limit => 2147483647
    t.timestamp "last_change"
  end

  create_table "data_group_3rdparty", :force => true do |t|
    t.string  "title",      :limit => 200
    t.boolean "is_deleted",                :default => false
  end

  create_table "data_group_advertise_agency", :force => true do |t|
    t.string  "title",      :limit => 200
    t.boolean "is_deleted",                :default => false
  end

  create_table "data_group_broadcast", :force => true do |t|
    t.string  "title",                  :limit => 200
    t.boolean "is_deleted",                            :default => false
    t.boolean "reachout_tab_is_active"
  end

  create_table "data_group_country", :force => true do |t|
    t.string  "title",       :limit => 200
    t.string  "iso_alpha_2", :limit => 2
    t.string  "iso_alpha_3", :limit => 3
    t.string  "iso_numeric", :limit => 3
    t.boolean "is_deleted",                 :default => false
  end

  create_table "data_group_genre", :force => true do |t|
    t.string  "title",      :limit => 200
    t.boolean "is_deleted",                :default => false
  end

  create_table "data_group_language", :force => true do |t|
    t.string  "title",      :limit => 200
    t.boolean "is_deleted",                :default => false
  end

  create_table "data_group_rca", :force => true do |t|
    t.string  "title",                  :limit => 200
    t.boolean "is_deleted",                            :default => false
    t.boolean "reachout_tab_is_active"
  end

  create_table "data_listener", :force => true do |t|
    t.string  "title",                      :limit => 200
    t.boolean "flag_push_marketing_opt_in",                :default => false
    t.string  "area_code"
  end

  create_table "data_listener_ani", :force => true do |t|
    t.integer  "listener_id",        :limit => 8
    t.string   "ani_e164",           :limit => 64
    t.integer  "carrier_id",         :limit => 8
    t.datetime "carrier_last_check"
    t.string   "carrier_OCN",        :limit => 32
  end

  add_index "data_listener_ani", ["ani_e164"], :name => "ani"
  add_index "data_listener_ani", ["carrier_id"], :name => "fk_data_listener_ani_2_idx"
  add_index "data_listener_ani", ["carrier_last_check"], :name => "lastcheck"
  add_index "data_listener_ani", ["listener_id"], :name => "fk_data_listener_ani_1_idx"

  create_table "data_listener_ani_carrier", :force => true do |t|
    t.string "title", :limit => 200
    t.string "OCN",   :limit => 32
  end

  add_index "data_listener_ani_carrier", ["OCN"], :name => "index2", :unique => true

  create_table "data_listener_at_campaign", :force => true do |t|
    t.integer   "listener_id",                                           :limit => 8
    t.integer   "context_at_id",                                         :limit => 8
    t.timestamp "statistics_first_session_date"
    t.datetime  "statistics_last_session_date"
    t.datetime  "statistics_interruption_first_session_date"
    t.datetime  "statistics_interruption_last_session_date"
    t.string    "statistics_interruption_last_sessions_timestamp",       :limit => 1024
    t.string    "statistics_interruption_last_sessions_log_campaign_id", :limit => 1024
    t.integer   "statistics_interruption_sessions_count",                :limit => 8
    t.integer   "statistics_interruption_sessions_seconds",              :limit => 8
    t.datetime  "statistics_request_first_session_date"
    t.datetime  "statistics_request_last_session_date"
    t.string    "statistics_request_last_sessions_timestamp",            :limit => 1024
    t.string    "statistics_request_last_sessions_log_campaign_id",      :limit => 1024
    t.integer   "statistics_request_sessions_count",                     :limit => 8
    t.integer   "statistics_request_sessions_seconds",                   :limit => 8
  end

  add_index "data_listener_at_campaign", ["listener_id"], :name => "fk_data_listener_at_campaign_1_idx"
  add_index "data_listener_at_campaign", ["statistics_first_session_date"], :name => "index2"

  create_table "data_listener_at_content", :force => true do |t|
    t.integer   "listener_id",                            :limit => 8
    t.integer   "context_at_id",                          :limit => 8
    t.timestamp "statistics_first_session_date"
    t.datetime  "statistics_last_session_date"
    t.string    "statistics_last_sessions_timestamp",     :limit => 1024
    t.string    "statistics_last_sessions_log_listen_id", :limit => 1024
    t.integer   "statistics_sessions_count",              :limit => 8
    t.integer   "statistics_sessions_seconds",            :limit => 8
  end

  add_index "data_listener_at_content", ["context_at_id"], :name => "fk_data_listener_at_content_2_idx"
  add_index "data_listener_at_content", ["listener_id"], :name => "fk_data_listener_at_content_1_idx"
  add_index "data_listener_at_content", ["statistics_last_session_date"], :name => "index5"

  create_table "data_listener_at_entryway", :force => true do |t|
    t.integer   "listener_id",                            :limit => 8
    t.integer   "context_at_id",                          :limit => 8
    t.timestamp "statistics_first_session_date"
    t.datetime  "statistics_last_session_date"
    t.string    "statistics_last_sessions_timestamp",     :limit => 1024
    t.string    "statistics_last_sessions_log_listen_id", :limit => 1024
    t.integer   "statistics_sessions_count",              :limit => 8
    t.integer   "statistics_sessions_seconds",            :limit => 8
  end

  add_index "data_listener_at_entryway", ["context_at_id"], :name => "fk_data_listener_at_entryway_2_idx"
  add_index "data_listener_at_entryway", ["listener_id"], :name => "fk_data_listener_at_entryway_1_idx"
  add_index "data_listener_at_entryway", ["statistics_last_session_date"], :name => "index4"

  create_table "data_listener_at_gateway", :force => true do |t|
    t.integer   "listener_id",                            :limit => 8
    t.integer   "context_at_id",                          :limit => 8
    t.timestamp "statistics_first_session_date"
    t.datetime  "statistics_last_session_date"
    t.string    "statistics_last_sessions_timestamp",     :limit => 1024
    t.string    "statistics_last_sessions_log_listen_id", :limit => 1024
    t.integer   "statistics_sessions_count",              :limit => 8
    t.integer   "statistics_sessions_seconds",            :limit => 8
  end

  add_index "data_listener_at_gateway", ["context_at_id"], :name => "fk_data_listener_at_gateway_2"
  add_index "data_listener_at_gateway", ["listener_id"], :name => "fk_data_listener_at_gateway_1"
  add_index "data_listener_at_gateway", ["statistics_last_session_date"], :name => "index4"

  create_table "data_listener_token", :force => true do |t|
    t.integer  "listener_id",   :limit => 8
    t.string   "token",         :limit => 64
    t.datetime "date_creation"
  end

  add_index "data_listener_token", ["listener_id"], :name => "listener"
  add_index "data_listener_token", ["token"], :name => "token", :unique => true

  create_table "default_prompt", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "prompt_file_name"
    t.string   "prompt_content_type"
    t.integer  "prompt_file_size"
    t.datetime "prompt_updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "log_call", :force => true do |t|
    t.integer  "server_id",             :limit => 8
    t.string   "asterisk_remote_ip",    :limit => 15
    t.datetime "date_start"
    t.datetime "date_stop"
    t.integer  "seconds"
    t.string   "ani_e164",              :limit => 64
    t.string   "did_e164",              :limit => 64
    t.integer  "listener_id",           :limit => 8
    t.integer  "listener_ani_id",       :limit => 8
    t.boolean  "listener_is_anonymous",               :default => false
    t.integer  "entryway_id",           :limit => 8
    t.integer  "gateway_id",            :limit => 8
    t.boolean  "on_summary",                          :default => false
  end

  add_index "log_call", ["date_start"], :name => "date_start"
  add_index "log_call", ["date_stop"], :name => "date_stop"
  add_index "log_call", ["entryway_id", "date_start"], :name => "entryway"
  add_index "log_call", ["gateway_id", "date_start"], :name => "gateway"
  add_index "log_call", ["listener_ani_id", "date_start"], :name => "list_ani"
  add_index "log_call", ["listener_id", "date_start"], :name => "listener"
  add_index "log_call", ["on_summary"], :name => "on_summary"
  add_index "log_call", ["server_id", "date_start"], :name => "server"

  create_table "log_call_2013_08", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2013_09", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2013_10", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2013_11", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2013_12", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2014_01", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2014_02", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
    t.integer "seconds"
    t.integer "ani_e164"
  end

  create_table "log_call_2014_03", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
  end

  create_table "log_call_2014_04", :force => true do |t|
    t.date    "date_start"
    t.integer "listener_id"
    t.integer "gateway_id"
    t.integer "entryway_id"
  end

  create_table "log_call_old", :force => true do |t|
    t.integer  "server_id",             :limit => 8
    t.string   "asterisk_remote_ip",    :limit => 15
    t.datetime "date_start"
    t.datetime "date_stop"
    t.integer  "seconds"
    t.string   "ani_e164",              :limit => 64
    t.string   "did_e164",              :limit => 64
    t.integer  "listener_id",           :limit => 8
    t.integer  "listener_ani_id",       :limit => 8
    t.boolean  "listener_is_anonymous",               :default => false
    t.integer  "entryway_id",           :limit => 8
    t.integer  "gateway_id",            :limit => 8
    t.boolean  "on_summary",                          :default => false
  end

  add_index "log_call_old", ["date_start"], :name => "date_start"
  add_index "log_call_old", ["date_stop"], :name => "date_stop"

  create_table "log_campaign", :force => true do |t|
    t.integer  "log_call_id",                         :limit => 8
    t.integer  "log_listen_id",                       :limit => 8
    t.datetime "date_start"
    t.datetime "date_stop"
    t.integer  "campaign_id",                         :limit => 8
    t.enum     "trigger_type",                        :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "advertise_prompt_id",                 :limit => 8
    t.integer  "listener_id",                         :limit => 8
    t.boolean  "listener_is_anonymous"
    t.integer  "listener_interruption_play_count",    :limit => 8,                                                                                                                                    :default => 0
    t.integer  "listener_request_play_count",         :limit => 8
    t.integer  "seconds",                                                                                                                                                                             :default => 0
    t.integer  "seconds_played",                      :limit => 8
    t.float    "cost_per_play",                                                                                                                                                                       :default => 0.0
    t.float    "cost_per_unique_listener"
    t.float    "cost"
    t.boolean  "is_interruption",                                                                                                                                                                     :default => false
    t.boolean  "is_request",                                                                                                                                                                          :default => false
    t.boolean  "is_playprompt",                                                                                                                                                                       :default => false
    t.boolean  "is_siptransfer",                                                                                                                                                                      :default => false
    t.boolean  "is_perlistener",                                                                                                                                                                      :default => false
    t.boolean  "is_perconference",                                                                                                                                                                    :default => false
    t.boolean  "listener_is_first_time_interruption",                                                                                                                                                 :default => false
    t.boolean  "listener_is_first_time_request",                                                                                                                                                      :default => false
    t.string   "siptransfer_sip_string"
    t.enum     "siptransfer_callid_mode",             :limit => [:CLEAN, :LISTENERANI, :LISTENERID]
    t.string   "siptransfer_callid_sent"
    t.string   "siptransfer_asterisk_dialstatus",     :limit => 32
    t.string   "siptransfer_asterisk_hangupcause",    :limit => 16
    t.boolean  "on_summary",                                                                                                                                                                          :default => false
  end

  add_index "log_campaign", ["campaign_id", "date_start"], :name => "campaign"
  add_index "log_campaign", ["date_start"], :name => "date_start"
  add_index "log_campaign", ["date_stop"], :name => "date_stop"
  add_index "log_campaign", ["listener_id", "date_start"], :name => "listener"
  add_index "log_campaign", ["log_call_id"], :name => "log_call"
  add_index "log_campaign", ["log_listen_id"], :name => "log_listen"
  add_index "log_campaign", ["on_summary"], :name => "on_summary"

  create_table "log_campaign_old", :force => true do |t|
    t.integer  "log_call_id",                         :limit => 8
    t.integer  "log_listen_id",                       :limit => 8
    t.datetime "date_start"
    t.datetime "date_stop"
    t.integer  "campaign_id",                         :limit => 8
    t.enum     "trigger_type",                        :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "advertise_prompt_id",                 :limit => 8
    t.integer  "listener_id",                         :limit => 8
    t.boolean  "listener_is_anonymous"
    t.integer  "listener_interruption_play_count",    :limit => 8,                                                                                                                                    :default => 0
    t.integer  "listener_request_play_count",         :limit => 8
    t.integer  "seconds",                                                                                                                                                                             :default => 0
    t.integer  "seconds_played",                      :limit => 8
    t.float    "cost_per_play",                                                                                                                                                                       :default => 0.0
    t.float    "cost_per_unique_listener"
    t.float    "cost"
    t.boolean  "is_interruption"
    t.boolean  "is_request"
    t.boolean  "is_playprompt"
    t.boolean  "is_siptransfer"
    t.boolean  "is_perlistener"
    t.boolean  "is_perconference"
    t.boolean  "listener_is_first_time_interruption",                                                                                                                                                 :default => false
    t.boolean  "listener_is_first_time_request",                                                                                                                                                      :default => false
    t.string   "siptransfer_sip_string"
    t.enum     "siptransfer_callid_mode",             :limit => [:CLEAN, :LISTENERANI, :LISTENERID]
    t.string   "siptransfer_callid_sent"
    t.string   "siptransfer_asterisk_dialstatus",     :limit => 32
    t.string   "siptransfer_asterisk_hangupcause",    :limit => 16
  end

  add_index "log_campaign_old", ["date_start"], :name => "date_start"
  add_index "log_campaign_old", ["date_stop"], :name => "date_stop"

  create_table "log_campaign_siptransfer", :force => true do |t|
    t.integer  "log_call_id",          :limit => 8
    t.integer  "log_listen_id",        :limit => 8
    t.integer  "log_campaign_id",      :limit => 8
    t.datetime "date_start"
    t.datetime "date_stop"
    t.string   "sip_string"
    t.enum     "callid_mode",          :limit => [:CLEAN, :LISTENERANI, :LISTENERID]
    t.string   "callid_sent"
    t.integer  "seconds",                                                             :default => 0
    t.string   "asterisk_dialstatus",  :limit => 32
    t.string   "asterisk_hangupcause", :limit => 16
  end

  add_index "log_campaign_siptransfer", ["date_start"], :name => "date_start"
  add_index "log_campaign_siptransfer", ["date_stop"], :name => "date_stop"

  create_table "log_listen", :force => true do |t|
    t.integer  "server_id",             :limit => 8
    t.integer  "log_call_id",           :limit => 8
    t.datetime "date_start"
    t.datetime "date_stop"
    t.integer  "seconds",                             :default => 0
    t.string   "extension",             :limit => 16
    t.integer  "content_id",            :limit => 8
    t.integer  "gateway_conference_id", :limit => 8
    t.boolean  "on_summary",                          :default => false
  end

  add_index "log_listen", ["content_id", "date_start"], :name => "content_id"
  add_index "log_listen", ["date_start"], :name => "date_start"
  add_index "log_listen", ["date_stop"], :name => "date_stop"
  add_index "log_listen", ["gateway_conference_id", "date_start"], :name => "conference_id"
  add_index "log_listen", ["log_call_id"], :name => "log_call"
  add_index "log_listen", ["on_summary"], :name => "on_summary"

  create_table "log_listen_old", :force => true do |t|
    t.integer  "server_id",             :limit => 8
    t.integer  "log_call_id",           :limit => 8
    t.datetime "date_start"
    t.datetime "date_stop"
    t.integer  "seconds",                             :default => 0
    t.string   "extension",             :limit => 16
    t.integer  "content_id",            :limit => 8
    t.integer  "gateway_conference_id", :limit => 8
  end

  add_index "log_listen_old", ["date_start"], :name => "date_start"
  add_index "log_listen_old", ["date_stop"], :name => "date_stop"
  add_index "log_listen_old", ["log_call_id"], :name => "call"

  create_table "now_session", :force => true do |t|
    t.integer  "log_call_id",                                          :limit => 8
    t.integer  "log_listen_id",                                        :limit => 8
    t.integer  "log_campaign_id",                                      :limit => 8
    t.integer  "log_campaign_siptransfer_id",                          :limit => 8
    t.integer  "call_server_id",                                       :limit => 8
    t.datetime "call_date_start"
    t.string   "call_asterisk_sip_ip",                                 :limit => 15
    t.string   "call_asterisk_channel",                                :limit => 64
    t.string   "call_asterisk_uniqueid",                               :limit => 64
    t.string   "call_ani_e164",                                        :limit => 32
    t.string   "call_did_e164",                                        :limit => 32
    t.boolean  "call_listener_play_welcome",                                                                                                                                                                           :default => true
    t.integer  "call_listener_ani_id",                                 :limit => 8
    t.integer  "call_listener_id",                                     :limit => 8
    t.boolean  "call_listener_is_anonymous"
    t.integer  "call_entryway_id",                                     :limit => 8
    t.integer  "call_gateway_id",                                      :limit => 8
    t.boolean  "listen_active",                                                                                                                                                                                        :default => false
    t.datetime "listen_date_start"
    t.string   "listen_extension",                                     :limit => 16
    t.integer  "listen_content_id",                                    :limit => 8
    t.integer  "listen_gateway_conference_id",                         :limit => 8
    t.integer  "listen_server_id",                                     :limit => 8
    t.integer  "listen_last_played_campaign_id",                       :limit => 8
    t.datetime "listen_last_played_campaign_timestamp"
    t.integer  "listen_last_played_campaign_log_id",                   :limit => 8
    t.string   "listen_last_played_campaigns_interruption_timestamps"
    t.string   "listen_asterisk_channel",                              :limit => 64
    t.string   "listen_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_type",                                          :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.datetime "engine_date_start"
    t.integer  "engine_server_id",                                     :limit => 8
    t.string   "engine_asterisk_channel",                              :limit => 64
    t.string   "engine_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_advertise_trigger_type",                        :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "engine_campaign_id",                                   :limit => 8
    t.enum     "next_step_1_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_1_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_1_engine_campaign_id",                       :limit => 8
    t.enum     "next_step_2_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_2_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_2_engine_campaign_id",                       :limit => 8
    t.enum     "last_engine_type",                                     :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "last_engine_advertise_trigger_type",                   :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "last_engine_campaign_id",                              :limit => 8
  end

  add_index "now_session", ["engine_type"], :name => "engine_now"

  create_table "now_session_old", :force => true do |t|
    t.integer  "log_call_id",                                          :limit => 8
    t.integer  "log_listen_id",                                        :limit => 8
    t.integer  "log_campaign_id",                                      :limit => 8
    t.integer  "log_campaign_siptransfer_id",                          :limit => 8
    t.integer  "call_server_id",                                       :limit => 8
    t.datetime "call_date_start"
    t.string   "call_asterisk_sip_ip",                                 :limit => 15
    t.string   "call_asterisk_channel",                                :limit => 64
    t.string   "call_asterisk_uniqueid",                               :limit => 64
    t.string   "call_ani_e164",                                        :limit => 32
    t.string   "call_did_e164",                                        :limit => 32
    t.boolean  "call_listener_play_welcome",                                                                                                                                                                           :default => true
    t.integer  "call_listener_ani_id",                                 :limit => 8
    t.integer  "call_listener_id",                                     :limit => 8
    t.boolean  "call_listener_is_anonymous"
    t.integer  "call_entryway_id",                                     :limit => 8
    t.integer  "call_gateway_id",                                      :limit => 8
    t.boolean  "listen_active",                                                                                                                                                                                        :default => false
    t.datetime "listen_date_start"
    t.string   "listen_extension",                                     :limit => 16
    t.integer  "listen_content_id",                                    :limit => 8
    t.integer  "listen_gateway_conference_id",                         :limit => 8
    t.integer  "listen_server_id",                                     :limit => 8
    t.integer  "listen_last_played_campaign_id",                       :limit => 8
    t.datetime "listen_last_played_campaign_timestamp"
    t.integer  "listen_last_played_campaign_log_id",                   :limit => 8
    t.string   "listen_last_played_campaigns_interruption_timestamps"
    t.string   "listen_last_played_campaigns_interruption_ids"
    t.string   "listen_asterisk_channel",                              :limit => 64
    t.string   "listen_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_type",                                          :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.datetime "engine_date_start"
    t.integer  "engine_server_id",                                     :limit => 8
    t.string   "engine_asterisk_channel",                              :limit => 64
    t.string   "engine_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_advertise_trigger_type",                        :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "engine_campaign_id",                                   :limit => 8
    t.enum     "next_step_1_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_1_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_1_engine_campaign_id",                       :limit => 8
    t.enum     "next_step_2_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_2_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_2_engine_campaign_id",                       :limit => 8
    t.enum     "last_engine_type",                                     :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "last_engine_advertise_trigger_type",                   :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "last_engine_campaign_id",                              :limit => 8
  end

  add_index "now_session_old", ["call_asterisk_channel", "call_server_id"], :name => "search_call_by_channel"
  add_index "now_session_old", ["call_date_start"], :name => "date_start"
  add_index "now_session_old", ["call_server_id"], :name => "call_server"
  add_index "now_session_old", ["engine_type"], :name => "engine_now"

  create_table "now_session_storage_errors", :primary_key => "error_id", :force => true do |t|
    t.integer  "id",                                                   :limit => 8
    t.integer  "log_call_id",                                          :limit => 8
    t.integer  "log_listen_id",                                        :limit => 8
    t.integer  "log_campaign_id",                                      :limit => 8
    t.integer  "log_campaign_siptransfer_id",                          :limit => 8
    t.integer  "call_server_id",                                       :limit => 8
    t.datetime "call_date_start"
    t.string   "call_asterisk_sip_ip",                                 :limit => 15
    t.string   "call_asterisk_channel",                                :limit => 64
    t.string   "call_asterisk_uniqueid",                               :limit => 64
    t.string   "call_ani_e164",                                        :limit => 32
    t.string   "call_did_e164",                                        :limit => 32
    t.boolean  "call_listener_play_welcome",                                                                                                                                                                           :default => true
    t.integer  "call_listener_ani_id",                                 :limit => 8
    t.integer  "call_listener_id",                                     :limit => 8
    t.boolean  "call_listener_is_anonymous"
    t.integer  "call_entryway_id",                                     :limit => 8
    t.integer  "call_gateway_id",                                      :limit => 8
    t.boolean  "listen_active",                                                                                                                                                                                        :default => false
    t.datetime "listen_date_start"
    t.string   "listen_extension",                                     :limit => 16
    t.integer  "listen_content_id",                                    :limit => 8
    t.integer  "listen_gateway_conference_id",                         :limit => 8
    t.integer  "listen_server_id",                                     :limit => 8
    t.integer  "listen_last_played_campaign_id",                       :limit => 8
    t.datetime "listen_last_played_campaign_timestamp"
    t.integer  "listen_last_played_campaign_log_id",                   :limit => 8
    t.string   "listen_last_played_campaigns_interruption_timestamps"
    t.string   "listen_asterisk_channel",                              :limit => 64
    t.string   "listen_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_type",                                          :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.datetime "engine_date_start"
    t.integer  "engine_server_id",                                     :limit => 8
    t.string   "engine_asterisk_channel",                              :limit => 64
    t.string   "engine_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_advertise_trigger_type",                        :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "engine_campaign_id",                                   :limit => 8
    t.enum     "next_step_1_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_1_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_1_engine_campaign_id",                       :limit => 8
    t.enum     "next_step_2_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_2_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_2_engine_campaign_id",                       :limit => 8
    t.enum     "last_engine_type",                                     :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "last_engine_advertise_trigger_type",                   :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "last_engine_campaign_id",                              :limit => 8
    t.datetime "error_date"
  end

  add_index "now_session_storage_errors", ["engine_type"], :name => "engine_now"

  create_table "now_session_storage_errors_old", :primary_key => "error_id", :force => true do |t|
    t.integer  "id",                                                   :limit => 8
    t.integer  "log_call_id",                                          :limit => 8
    t.integer  "log_listen_id",                                        :limit => 8
    t.integer  "log_campaign_id",                                      :limit => 8
    t.integer  "log_campaign_siptransfer_id",                          :limit => 8
    t.integer  "call_server_id",                                       :limit => 8
    t.datetime "call_date_start"
    t.string   "call_asterisk_sip_ip",                                 :limit => 15
    t.string   "call_asterisk_channel",                                :limit => 64
    t.string   "call_asterisk_uniqueid",                               :limit => 64
    t.string   "call_ani_e164",                                        :limit => 32
    t.string   "call_did_e164",                                        :limit => 32
    t.boolean  "call_listener_play_welcome",                                                                                                                                                                           :default => true
    t.integer  "call_listener_ani_id",                                 :limit => 8
    t.integer  "call_listener_id",                                     :limit => 8
    t.boolean  "call_listener_is_anonymous"
    t.integer  "call_entryway_id",                                     :limit => 8
    t.integer  "call_gateway_id",                                      :limit => 8
    t.boolean  "listen_active",                                                                                                                                                                                        :default => false
    t.datetime "listen_date_start"
    t.string   "listen_extension",                                     :limit => 16
    t.integer  "listen_content_id",                                    :limit => 8
    t.integer  "listen_gateway_conference_id",                         :limit => 8
    t.integer  "listen_server_id",                                     :limit => 8
    t.integer  "listen_last_played_campaign_id",                       :limit => 8
    t.datetime "listen_last_played_campaign_timestamp"
    t.integer  "listen_last_played_campaign_log_id",                   :limit => 8
    t.string   "listen_last_played_campaigns_interruption_timestamps"
    t.string   "listen_asterisk_channel",                              :limit => 64
    t.string   "listen_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_type",                                          :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.datetime "engine_date_start"
    t.integer  "engine_server_id",                                     :limit => 8
    t.string   "engine_asterisk_channel",                              :limit => 64
    t.string   "engine_asterisk_uniqueid",                             :limit => 64
    t.enum     "engine_advertise_trigger_type",                        :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "engine_campaign_id",                                   :limit => 8
    t.enum     "next_step_1_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_1_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_1_engine_campaign_id",                       :limit => 8
    t.enum     "next_step_2_engine_type",                              :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "next_step_2_engine_advertise_trigger_type",            :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "next_step_2_engine_campaign_id",                       :limit => 8
    t.enum     "last_engine_type",                                     :limit => [:LISTEN, :TALK, :PRIVATETALK, :ADVERTISE, :ADVERTISESIPTRANSFER, :HANGUP]
    t.enum     "last_engine_advertise_trigger_type",                   :limit => [:LISTENERMANUAL, :LISTENERTIMEOUT, :LISTENERPREROLL, :LISTENERREQUEST, :CONFERENCEMANUAL, :CONFERENCETIMEOUT, :CONFERENCEADREPLACE]
    t.integer  "last_engine_campaign_id",                              :limit => 8
    t.datetime "error_date"
  end

  add_index "now_session_storage_errors_old", ["engine_type"], :name => "engine_now"

  create_table "pending_users", :force => true do |t|
    t.string   "station_name"
    t.string   "company_name"
    t.string   "streaming_url"
    t.string   "status",          :default => "unprocessed"
    t.string   "website"
    t.string   "genre"
    t.string   "language"
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "signup_date"
    t.text     "note"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.datetime "date_processed"
    t.string   "affiliate"
    t.string   "rca"
    t.boolean  "enabled",         :default => true
    t.string   "on_air_schedule"
  end

  create_table "reachout_tab_campaign", :force => true do |t|
    t.integer  "gateway_id"
    t.integer  "did_e164"
    t.boolean  "generic_prompt"
    t.datetime "schedule_start_date"
    t.datetime "schedule_end_date"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "prompt_file_name"
    t.string   "prompt_content_type"
    t.integer  "prompt_file_size"
    t.datetime "prompt_updated_at"
    t.string   "campaign_id"
    t.boolean  "status"
    t.integer  "created_by"
  end

  create_table "reachout_tab_campaign_listener", :force => true do |t|
    t.integer  "campaign_id"
    t.string   "phone_number"
    t.datetime "campaign_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "gateway_id"
  end

  create_table "reachout_tab_listener_minutes_by_gateway", :force => true do |t|
    t.integer  "listener_id"
    t.string   "ani_e164"
    t.integer  "gateway_id"
    t.string   "did_e164"
    t.integer  "minutes"
    t.datetime "created_at",                   :null => false
    t.integer  "carrier_id",      :limit => 8
    t.string   "carrier_title"
    t.integer  "listener_ani_id", :limit => 8
  end

  create_table "reachout_tab_mapping_rule", :force => true do |t|
    t.integer  "carrier_id",        :limit => 8
    t.string   "carrier_title"
    t.integer  "entryway_id",       :limit => 8
    t.string   "entryway_provider"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "report_2013_2", :force => true do |t|
    t.date     "report_date"
    t.integer  "active_users"
    t.integer  "new_users"
    t.integer  "users_by_time"
    t.integer  "sessions"
    t.integer  "total_minutes"
    t.integer  "gateway_id"
    t.datetime "created_at",    :null => false
  end

  create_table "report_2014_1", :force => true do |t|
    t.date     "report_date"
    t.integer  "active_users"
    t.integer  "new_users"
    t.integer  "users_by_time"
    t.integer  "sessions"
    t.integer  "total_minutes"
    t.integer  "gateway_id"
    t.datetime "created_at",    :null => false
  end

  create_table "report_by_did_2013_2", :force => true do |t|
    t.date     "report_date"
    t.integer  "active_users"
    t.integer  "new_users"
    t.integer  "users_by_time"
    t.integer  "sessions"
    t.integer  "total_minutes"
    t.integer  "entryway_id"
    t.datetime "created_at",    :null => false
  end

  create_table "report_by_did_2014_1", :force => true do |t|
    t.date     "report_date"
    t.integer  "active_users"
    t.integer  "new_users"
    t.integer  "users_by_time"
    t.integer  "sessions"
    t.integer  "total_minutes"
    t.integer  "entryway_id"
    t.datetime "created_at",    :null => false
  end

  create_table "report_listener_by_gateway_id", :force => true do |t|
    t.integer  "gateway_id"
    t.integer  "total_listeners"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "report_listener_totals", :force => true do |t|
    t.integer  "sys_user_id"
    t.integer  "total_listeners"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "report_summary_listen", :force => true do |t|
    t.date     "report_date"
    t.integer  "total_minutes"
    t.integer  "gateway_id"
    t.integer  "content_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "report_total_minutes_by_hour", :force => true do |t|
    t.integer  "report_hours"
    t.integer  "total_minutes"
    t.integer  "gateway_id"
    t.datetime "created_at",    :null => false
    t.date     "report_date"
  end

  create_table "report_users_by_time", :force => true do |t|
    t.date     "report_date"
    t.integer  "report_hours"
    t.integer  "users_by_time"
    t.integer  "gateway_id"
    t.datetime "created_at",    :null => false
  end

  create_table "stream_checker_log", :id => false, :force => true do |t|
    t.integer  "id",                              :null => false
    t.string   "url",                             :null => false
    t.integer  "http_status"
    t.string   "media_type"
    t.float    "open_time",         :limit => 15
    t.float    "resp_time",         :limit => 15
    t.float    "close_time",        :limit => 15
    t.datetime "date_time_checked"
  end

  create_table "summary_call", :force => true do |t|
    t.datetime "date"
    t.integer  "entryway_id",             :limit => 8
    t.integer  "listener_ani_carrier_id", :limit => 8
    t.integer  "count",                   :limit => 3
    t.integer  "seconds",                 :limit => 3
  end

  add_index "summary_call", ["date"], :name => "date"
  add_index "summary_call", ["entryway_id"], :name => "e"
  add_index "summary_call", ["listener_ani_carrier_id"], :name => "c"

  create_table "summary_campaign", :force => true do |t|
    t.datetime "date"
    t.integer  "campaign_id",                 :limit => 8
    t.integer  "entryway_id",                 :limit => 8
    t.integer  "gateway_id",                  :limit => 8
    t.integer  "content_id",                  :limit => 8
    t.integer  "count_interruption",          :limit => 3
    t.integer  "count_request",               :limit => 3
    t.integer  "count_request_prompt",        :limit => 3
    t.integer  "count_request_siptransfer",   :limit => 3
    t.integer  "seconds_interruption",        :limit => 3
    t.integer  "seconds_request",             :limit => 3
    t.integer  "seconds_request_prompt",      :limit => 3
    t.integer  "seconds_request_siptransfer", :limit => 3
  end

  add_index "summary_campaign", ["campaign_id"], :name => "ad"
  add_index "summary_campaign", ["content_id"], :name => "c"
  add_index "summary_campaign", ["date"], :name => "date"
  add_index "summary_campaign", ["entryway_id"], :name => "e"
  add_index "summary_campaign", ["gateway_id"], :name => "g"

  create_table "summary_listen", :force => true do |t|
    t.datetime "date"
    t.integer  "entryway_id",       :limit => 8
    t.integer  "gateway_id",        :limit => 8
    t.integer  "content_id",        :limit => 8
    t.integer  "count",             :limit => 3
    t.integer  "count_acd_10sec",   :limit => 3
    t.integer  "count_acd_1min",    :limit => 3
    t.integer  "count_acd_5min",    :limit => 3
    t.integer  "count_acd_20min",   :limit => 3
    t.integer  "count_acd_1hr",     :limit => 3
    t.integer  "count_acd_2hr",     :limit => 3
    t.integer  "count_acd_6hr",     :limit => 3
    t.integer  "count_acd_more6hr", :limit => 3
    t.integer  "seconds",           :limit => 3
  end

  add_index "summary_listen", ["content_id"], :name => "c"
  add_index "summary_listen", ["date"], :name => "date"
  add_index "summary_listen", ["entryway_id"], :name => "e"
  add_index "summary_listen", ["gateway_id"], :name => "g"

  create_table "summary_listeners_by_campaign", :force => true do |t|
    t.date    "date"
    t.integer "campaign_id",                        :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_campaign", ["date"], :name => "date"

  create_table "summary_listeners_by_content", :force => true do |t|
    t.date    "date"
    t.integer "content_id",                         :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_content", ["content_id"], :name => "fk_summary_listeners_by_content_1_idx"
  add_index "summary_listeners_by_content", ["date"], :name => "date"

  create_table "summary_listeners_by_content_broadcast", :force => true do |t|
    t.date    "date"
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
    t.integer "broadcast_id",                       :limit => 8
  end

  add_index "summary_listeners_by_content_broadcast", ["broadcast_id"], :name => "fk_summary_listeners_by_content_broadcast_1_idx"
  add_index "summary_listeners_by_content_broadcast", ["date"], :name => "date"

  create_table "summary_listeners_by_content_country", :force => true do |t|
    t.date    "date"
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
    t.integer "country_id",                         :limit => 8
  end

  add_index "summary_listeners_by_content_country", ["country_id"], :name => "fk_summary_listeners_by_content_country_1_idx"
  add_index "summary_listeners_by_content_country", ["date"], :name => "date"

  create_table "summary_listeners_by_content_language", :force => true do |t|
    t.date    "date"
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
    t.integer "language_id",                        :limit => 8
  end

  add_index "summary_listeners_by_content_language", ["date"], :name => "date"
  add_index "summary_listeners_by_content_language", ["language_id"], :name => "fk_summary_listeners_by_content_language_1_idx"

  create_table "summary_listeners_by_entryway", :force => true do |t|
    t.date    "date"
    t.integer "entryway_id",                        :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_entryway", ["date"], :name => "date"
  add_index "summary_listeners_by_entryway", ["entryway_id"], :name => "fk_summary_listeners_by_entryway_1_idx"

  create_table "summary_listeners_by_entryway_3rdparty", :force => true do |t|
    t.date    "date"
    t.integer "3rdparty_id",                        :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_entryway_3rdparty", ["3rdparty_id"], :name => "fk_summary_listeners_by_entryway_3rdparty_1_idx"
  add_index "summary_listeners_by_entryway_3rdparty", ["date"], :name => "date"

  create_table "summary_listeners_by_gateway", :force => true do |t|
    t.date    "date"
    t.integer "gateway_id",                         :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_gateway", ["date"], :name => "date"
  add_index "summary_listeners_by_gateway", ["gateway_id"], :name => "fk_summary_listeners_by_gateway_1_idx"

  create_table "summary_listeners_by_gateway_broadcast", :force => true do |t|
    t.date    "date"
    t.integer "broadcast_id",                       :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_gateway_broadcast", ["broadcast_id"], :name => "fk_summary_listeners_by_gateway_broadcast_1_idx"
  add_index "summary_listeners_by_gateway_broadcast", ["date"], :name => "date"

  create_table "summary_listeners_by_gateway_rca", :force => true do |t|
    t.date    "date"
    t.integer "rca_id",                             :limit => 8
    t.integer "status_not_active"
    t.integer "status_active"
    t.integer "status_lost"
    t.integer "active_by_new"
    t.integer "active_by_return"
    t.integer "frequency_listen_dialy"
    t.integer "frequency_listen_weekly"
    t.integer "frequency_unknown"
    t.integer "frequency_0_to_5_minutes_per_day"
    t.integer "frequency_5_to_20_minutes_per_day"
    t.integer "frequency_20_to_60_minutes_per_day"
    t.integer "frequency_more_60_minutes_per_day"
  end

  add_index "summary_listeners_by_gateway_rca", ["date"], :name => "date"
  add_index "summary_listeners_by_gateway_rca", ["rca_id"], :name => "fk_summary_listeners_by_gateway_rca_1_idx"

  create_table "summary_sessions_by_campaign", :force => true do |t|
    t.date    "date"
    t.integer "hour"
    t.integer "campaign_id",       :limit => 8
    t.integer "campaign_media_id", :limit => 8
    t.integer "sessions",          :limit => 8
    t.integer "seconds",           :limit => 3
    t.float   "usage_points"
    t.float   "price_entryway"
    t.float   "price_gateway"
    t.float   "price_content"
    t.float   "price_campaign"
  end

  add_index "summary_sessions_by_campaign", ["date", "hour"], :name => "datehr"
  add_index "summary_sessions_by_campaign", ["date"], :name => "date"

  create_table "summary_sessions_by_content", :force => true do |t|
    t.date    "date"
    t.integer "hour"
    t.integer "content_id",           :limit => 8
    t.integer "country_id",           :limit => 8
    t.integer "language_id",          :limit => 8
    t.integer "genre_id",             :limit => 8
    t.integer "broadcast_id",         :limit => 8
    t.integer "sessions",             :limit => 8
    t.integer "sessions_acd_10sec",   :limit => 3
    t.integer "sessions_acd_1min",    :limit => 3
    t.integer "sessions_acd_5min",    :limit => 3
    t.integer "sessions_acd_20min",   :limit => 3
    t.integer "sessions_acd_1hr",     :limit => 3
    t.integer "sessions_acd_2hr",     :limit => 3
    t.integer "sessions_acd_6hr",     :limit => 3
    t.integer "sessions_acd_more6hr", :limit => 3
    t.integer "seconds",              :limit => 3
  end

  add_index "summary_sessions_by_content", ["broadcast_id"], :name => "fk_summary_minutes_listen_sessions_content_5_idx"
  add_index "summary_sessions_by_content", ["content_id"], :name => "fk_summary_minutes_listen_sessions_content_1_idx"
  add_index "summary_sessions_by_content", ["country_id"], :name => "fk_summary_minutes_listen_sessions_content_2_idx"
  add_index "summary_sessions_by_content", ["date", "hour"], :name => "datehr"
  add_index "summary_sessions_by_content", ["date"], :name => "date"
  add_index "summary_sessions_by_content", ["genre_id"], :name => "fk_summary_minutes_listen_sessions_content_4_idx"
  add_index "summary_sessions_by_content", ["language_id"], :name => "fk_summary_minutes_listen_sessions_content_3_idx"

  create_table "summary_sessions_by_entryway", :force => true do |t|
    t.date    "date"
    t.integer "hour"
    t.integer "entryway_id",          :limit => 8
    t.integer "entryway_provider_id", :limit => 8
    t.integer "country_id",           :limit => 8
    t.integer "3rdparty_id",          :limit => 8
    t.integer "sessions",             :limit => 3
    t.integer "sessions_acd_10sec",   :limit => 3
    t.integer "sessions_acd_1min",    :limit => 3
    t.integer "sessions_acd_5min",    :limit => 3
    t.integer "sessions_acd_20min",   :limit => 3
    t.integer "sessions_acd_1hr",     :limit => 3
    t.integer "sessions_acd_2hr",     :limit => 3
    t.integer "sessions_acd_6hr",     :limit => 3
    t.integer "sessions_acd_more6hr", :limit => 3
    t.integer "seconds",              :limit => 3
  end

  add_index "summary_sessions_by_entryway", ["3rdparty_id"], :name => "fk_summary_sessions_by_entryway_4_idx"
  add_index "summary_sessions_by_entryway", ["country_id"], :name => "fk_summary_sessions_by_entryway_3_idx"
  add_index "summary_sessions_by_entryway", ["date", "hour"], :name => "datehr"
  add_index "summary_sessions_by_entryway", ["date"], :name => "date"
  add_index "summary_sessions_by_entryway", ["entryway_id"], :name => "fk_summary_sessions_by_entryway_1_idx"
  add_index "summary_sessions_by_entryway", ["entryway_provider_id"], :name => "fk_summary_sessions_by_entryway_2_idx"

  create_table "summary_sessions_by_gateway", :force => true do |t|
    t.date    "date"
    t.integer "hour"
    t.integer "gateway_id",           :limit => 8
    t.integer "country_id",           :limit => 8
    t.integer "language_id",          :limit => 8
    t.integer "rca_id",               :limit => 8
    t.integer "broadcast_id",         :limit => 8
    t.integer "sessions",             :limit => 8
    t.integer "sessions_acd_10sec",   :limit => 3
    t.integer "sessions_acd_1min",    :limit => 3
    t.integer "sessions_acd_5min",    :limit => 3
    t.integer "sessions_acd_20min",   :limit => 3
    t.integer "sessions_acd_1hr",     :limit => 3
    t.integer "sessions_acd_2hr",     :limit => 3
    t.integer "sessions_acd_6hr",     :limit => 3
    t.integer "sessions_acd_more6hr", :limit => 3
    t.integer "seconds",              :limit => 3
  end

  add_index "summary_sessions_by_gateway", ["broadcast_id"], :name => "fk_summary_minutes_listen_sessions_gateway_5_idx"
  add_index "summary_sessions_by_gateway", ["country_id"], :name => "fk_summary_minutes_listen_sessions_gateway_2_idx"
  add_index "summary_sessions_by_gateway", ["date", "hour"], :name => "datehr"
  add_index "summary_sessions_by_gateway", ["date"], :name => "date"
  add_index "summary_sessions_by_gateway", ["gateway_id"], :name => "fk_summary_minutes_listen_sessions_gateway_1_idx"
  add_index "summary_sessions_by_gateway", ["language_id"], :name => "fk_summary_minutes_listen_sessions_gateway_3_idx"
  add_index "summary_sessions_by_gateway", ["rca_id"], :name => "fk_summary_minutes_listen_sessions_gateway_4_idx"

  create_table "sys_config", :id => false, :force => true do |t|
    t.string "group", :limit => 64,  :null => false
    t.string "name",  :limit => 128, :null => false
    t.string "value"
  end

  create_table "sys_server", :force => true do |t|
    t.string  "title",                       :limit => 200
    t.string  "short_title",                 :limit => 16
    t.string  "ip",                          :limit => 15
    t.integer "location_id",                 :limit => 8
    t.string  "engine_media_remote_ip",      :limit => 200
    t.boolean "is_deleted",                                 :default => false
    t.boolean "flag_no_listener_preroll_ad",                :default => false
    t.boolean "flag_no_listener_timeout_ad",                :default => false
    t.boolean "flag_no",                                    :default => false
    t.boolean "flag_no_add_siptransfer",                    :default => false
    t.boolean "in_route"
  end

  add_index "sys_server", ["location_id"], :name => "fk_sys_server_1_idx"

  create_table "sys_server_location", :force => true do |t|
    t.string "title", :limit => 200
  end

  create_table "sys_task", :force => true do |t|
    t.string    "taskname",  :limit => 50, :null => false
    t.string    "taskvalue"
    t.timestamp "starttime",               :null => false
  end

  create_table "sys_task_result", :id => false, :force => true do |t|
    t.integer   "id",                                     :null => false
    t.string    "hostname", :limit => 50, :default => "", :null => false
    t.text      "res"
    t.timestamp "stoptime",                               :null => false
  end

  create_table "sys_user", :force => true do |t|
    t.integer  "permission_id",          :limit => 8
    t.string   "title"
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",                  :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "landline"
    t.string   "cellphone"
    t.boolean  "enabled"
    t.boolean  "is_deleted"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "barcode"
    t.string   "rca"
    t.string   "station_name"
    t.string   "streaming_url"
    t.string   "website"
    t.string   "language"
    t.string   "genre"
    t.string   "affiliate"
    t.string   "on_air_schedule"
  end

  add_index "sys_user", ["permission_id"], :name => "fk_sys_user_1"
  add_index "sys_user", ["permission_id"], :name => "fk_sys_user_1_idx"

  create_table "sys_user_countries", :force => true do |t|
    t.integer "user_id"
    t.integer "country_id"
  end

  create_table "sys_user_permission", :force => true do |t|
    t.string  "title",                                   :limit => 200
    t.boolean "is_super_user",                                          :default => false
    t.boolean "can_manage_specific_3rdparty_resources",                 :default => false
    t.boolean "can_manage_specific_broadcast_resources",                :default => false
    t.boolean "can_manage_specific_rca_resources",                      :default => false
    t.boolean "can_manage_all_zenoradio_data",                          :default => false
    t.boolean "can_manage_all_zenoradio_metadata",                      :default => false
    t.boolean "can_manage_all_zenoradio_users",                         :default => false
  end

  create_table "sys_user_resource_3rdparty", :force => true do |t|
    t.integer "user_id",     :limit => 8
    t.integer "3rdparty_id", :limit => 8
  end

  add_index "sys_user_resource_3rdparty", ["3rdparty_id"], :name => "fk_sys_user_resource_3rdparty_2_idx"
  add_index "sys_user_resource_3rdparty", ["user_id"], :name => "fk_sys_user_resource_3rdparty_1"

  create_table "sys_user_resource_advertise_agency", :force => true do |t|
    t.integer "user_id",             :limit => 8
    t.integer "advertise_agency_id", :limit => 8
  end

  add_index "sys_user_resource_advertise_agency", ["advertise_agency_id"], :name => "fk_sys_user_resource_advertise_agency_2_idx"
  add_index "sys_user_resource_advertise_agency", ["user_id"], :name => "fk_sys_user_resource_advertise_agency_1"

  create_table "sys_user_resource_broadcast", :force => true do |t|
    t.integer "user_id",      :limit => 8
    t.integer "broadcast_id", :limit => 8
  end

  add_index "sys_user_resource_broadcast", ["broadcast_id"], :name => "fk_sys_user_resource_broadcast_2_idx"
  add_index "sys_user_resource_broadcast", ["user_id"], :name => "fk_sys_user_resource_broadcast_1"

  create_table "sys_user_resource_rca", :force => true do |t|
    t.integer "user_id", :limit => 8
    t.integer "rca_id",  :limit => 8
  end

  add_index "sys_user_resource_rca", ["rca_id"], :name => "fk_sys_user_resource_rca_1_idx1"
  add_index "sys_user_resource_rca", ["user_id"], :name => "fk_sys_user_resource_rca_1"

  create_table "sys_user_tags", :force => true do |t|
    t.integer "user_id"
    t.string  "tag"
  end

  create_table "tags", :force => true do |t|
    t.string "title"
  end

  create_table "user_tags", :force => true do |t|
    t.integer "tag_id"
    t.integer "user_id"
  end

  add_index "user_tags", ["tag_id"], :name => "index_user_tags_on_tag_id"
  add_index "user_tags", ["user_id"], :name => "index_user_tags_on_user_id"

end
