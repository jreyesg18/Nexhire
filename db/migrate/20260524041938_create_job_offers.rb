class CreateJobOffers < ActiveRecord::Migration[8.1]
  def change
    create_table :job_offers do |t|
      t.references :recruiter, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.string :company_name
      t.text :description
      t.string :location
      t.string :salary
      t.integer :ideal_openness
      t.integer :ideal_conscientiousness
      t.integer :ideal_extraversion
      t.integer :ideal_agreeableness
      t.integer :ideal_neuroticism

      t.timestamps
    end
  end
end
