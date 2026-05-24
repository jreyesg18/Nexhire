class ApplicantProfile < ApplicationRecord
  belongs_to :user
  has_many :work_experiences, -> { order(start_date: :desc) }, dependent: :destroy
  has_many :educations, -> { order(start_date: :desc) }, dependent: :destroy
  has_one_attached :photo

  validates :name, presence: true

  def skill_list
    skills.to_s.split(",").map(&:strip).reject(&:empty?)
  end
end
