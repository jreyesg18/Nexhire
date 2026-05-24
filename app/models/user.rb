class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { applicant: 0, recruiter: 1 }

  has_one :applicant_profile, dependent: :destroy
  has_many :personality_test_results, dependent: :destroy
  has_many :job_offers, foreign_key: :recruiter_id, dependent: :destroy
  has_many :job_applications, foreign_key: :applicant_id, dependent: :destroy

  # Automatically create an empty applicant profile for applicants
  after_create :create_profile_if_applicant

  def latest_valid_test_result
    personality_test_results.where("completed_at >= ?", 90.days.ago).order(completed_at: :desc).first
  end

  def has_valid_test_result?
    latest_valid_test_result.present?
  end

  private

  def create_profile_if_applicant
    create_applicant_profile!(name: email.split("@").first.capitalize) if applicant?
  end
end
