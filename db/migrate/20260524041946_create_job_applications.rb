class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :job_applications do |t|
      t.references :applicant, null: false, foreign_key: { to_table: :users }
      t.references :job_offer, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.jsonb :ocean_snapshot

      t.timestamps
    end
  end
end
