class JobApplication < ApplicationRecord
  belongs_to :applicant, class_name: "User"
  belongs_to :job_offer

  STATUSES = %w[pending reviewed accepted rejected].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :job_offer_id, uniqueness: { scope: :applicant_id, message: "you have already applied to this job" }
  validate :applicant_has_valid_test_result, on: :create

  before_create :take_ocean_snapshot

  def match_percentage
    return 0.0 if ocean_snapshot.blank?

    o = ocean_snapshot["openness"].to_i
    c = ocean_snapshot["conscientiousness"].to_i
    e = ocean_snapshot["extraversion"].to_i
    a = ocean_snapshot["agreeableness"].to_i
    n = ocean_snapshot["neuroticism"].to_i

    job_offer.match_percentage_for_scores(o, c, e, a, n)
  end

  private

  def applicant_has_valid_test_result
    unless applicant&.has_valid_test_result?
      errors.add(:base, "You must complete the OCEAN personality test (and it must be within 90 days) before you can apply to jobs.")
    end
  end

  def take_ocean_snapshot
    result = applicant.latest_valid_test_result
    if result
      self.ocean_snapshot = {
        "openness" => result.openness,
        "conscientiousness" => result.conscientiousness,
        "extraversion" => result.extraversion,
        "agreeableness" => result.agreeableness,
        "neuroticism" => result.neuroticism,
        "completed_at" => result.completed_at
      }
    end
  end
end
