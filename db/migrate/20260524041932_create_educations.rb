class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.references :applicant_profile, null: false, foreign_key: true
      t.string :school
      t.string :degree
      t.string :field_of_study
      t.date :start_date
      t.date :end_date
      t.text :description

      t.timestamps
    end
  end
end
