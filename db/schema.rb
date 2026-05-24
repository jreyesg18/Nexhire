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

ActiveRecord::Schema[8.1].define(version: 2026_05_24_042147) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "applicant_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.text "skills"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_applicant_profiles_on_user_id"
  end

  create_table "educations", force: :cascade do |t|
    t.bigint "applicant_profile_id", null: false
    t.datetime "created_at", null: false
    t.string "degree"
    t.text "description"
    t.date "end_date"
    t.string "field_of_study"
    t.string "school"
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["applicant_profile_id"], name: "index_educations_on_applicant_profile_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.bigint "applicant_id", null: false
    t.datetime "created_at", null: false
    t.bigint "job_offer_id", null: false
    t.jsonb "ocean_snapshot"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_id"], name: "index_job_applications_on_applicant_id"
    t.index ["job_offer_id"], name: "index_job_applications_on_job_offer_id"
  end

  create_table "job_offers", force: :cascade do |t|
    t.string "company_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "ideal_agreeableness"
    t.integer "ideal_conscientiousness"
    t.integer "ideal_extraversion"
    t.integer "ideal_neuroticism"
    t.integer "ideal_openness"
    t.string "location"
    t.bigint "recruiter_id", null: false
    t.string "salary"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["recruiter_id"], name: "index_job_offers_on_recruiter_id"
  end

  create_table "personality_test_results", force: :cascade do |t|
    t.integer "agreeableness"
    t.datetime "completed_at"
    t.integer "conscientiousness"
    t.datetime "created_at", null: false
    t.integer "extraversion"
    t.integer "neuroticism"
    t.integer "openness"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_personality_test_results_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "work_experiences", force: :cascade do |t|
    t.bigint "applicant_profile_id", null: false
    t.string "company"
    t.datetime "created_at", null: false
    t.boolean "current"
    t.text "description"
    t.date "end_date"
    t.string "position"
    t.date "start_date"
    t.datetime "updated_at", null: false
    t.index ["applicant_profile_id"], name: "index_work_experiences_on_applicant_profile_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applicant_profiles", "users"
  add_foreign_key "educations", "applicant_profiles"
  add_foreign_key "job_applications", "job_offers"
  add_foreign_key "job_applications", "users", column: "applicant_id"
  add_foreign_key "job_offers", "users", column: "recruiter_id"
  add_foreign_key "personality_test_results", "users"
  add_foreign_key "work_experiences", "applicant_profiles"
end
