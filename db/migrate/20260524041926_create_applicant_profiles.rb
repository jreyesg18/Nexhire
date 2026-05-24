class CreateApplicantProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :applicant_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :skills

      t.timestamps
    end
  end
end
