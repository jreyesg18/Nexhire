class CreatePersonalityTestResults < ActiveRecord::Migration[8.1]
  def change
    create_table :personality_test_results do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :completed_at
      t.integer :openness
      t.integer :conscientiousness
      t.integer :extraversion
      t.integer :agreeableness
      t.integer :neuroticism

      t.timestamps
    end
  end
end
