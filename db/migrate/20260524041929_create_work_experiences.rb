class CreateWorkExperiences < ActiveRecord::Migration[8.1]
  def change
    create_table :work_experiences do |t|
      t.references :applicant_profile, null: false, foreign_key: true
      t.string :company
      t.string :position
      t.date :start_date
      t.date :end_date
      t.boolean :current
      t.text :description

      t.timestamps
    end
  end
end
