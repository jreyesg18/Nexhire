class JobOffer < ApplicationRecord
  belongs_to :recruiter, class_name: "User"
  has_many :job_applications, dependent: :destroy

  validates :title, :company_name, :description, :location, :salary, presence: true
  validates :ideal_openness, :ideal_conscientiousness, :ideal_extraversion, :ideal_agreeableness, :ideal_neuroticism,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def match_percentage_for_scores(o, c, e, a, n)
    diffs = [
      (o - ideal_openness).abs,
      (c - ideal_conscientiousness).abs,
      (e - ideal_extraversion).abs,
      (a - ideal_agreeableness).abs,
      (n - ideal_neuroticism).abs
    ]
    (100 - (diffs.sum / 5.0)).round(1)
  end

  def match_percentage_for_user(user)
    result = user.latest_valid_test_result
    return 0.0 unless result

    match_percentage_for_scores(
      result.openness,
      result.conscientiousness,
      result.extraversion,
      result.agreeableness,
      result.neuroticism
    )
  end
end
