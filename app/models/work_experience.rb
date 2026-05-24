class WorkExperience < ApplicationRecord
  belongs_to :applicant_profile

  validates :company, :position, :start_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if current? || end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
