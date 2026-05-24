class Applicants::PersonalityTestsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_applicant!

  def show
    @latest_result = current_user.personality_test_results.order(completed_at: :desc).first
  end

  def new
    @questions = PersonalityTestResult::QUESTIONS
    @latest_result = current_user.personality_test_results.order(completed_at: :desc).first
  end

  def create
    responses = params[:responses] || {}

    # Ensure all 30 questions are answered with values between 1 and 5
    missing = (1..30).reject do |id|
      responses[id.to_s].present? && (1..5).include?(responses[id.to_s].to_i)
    end

    if missing.any?
      flash.now[:alert] = "Please answer all 30 questions to submit the assessment."
      @questions = PersonalityTestResult::QUESTIONS
      @latest_result = current_user.personality_test_results.order(completed_at: :desc).first
      render :new, status: :unprocessable_entity
      return
    end

    # Heuristic scoring
    dimension_sums = {
      openness: 0,
      conscientiousness: 0,
      extraversion: 0,
      agreeableness: 0,
      neuroticism: 0
    }

    PersonalityTestResult::QUESTIONS.each do |q|
      response_val = responses[q[:id].to_s].to_i
      # Reverse score negatively keyed items (direction: -1)
      item_score = q[:direction] == 1 ? response_val : (6 - response_val)
      dimension_sums[q[:dimension].to_sym] += item_score
    end

    # Normalize to 0-100 range: ((sum - 6) / 24.0) * 100
    normalized_scores = {}
    dimension_sums.each do |dimension, sum|
      normalized_scores[dimension] = (((sum - 6) / 24.0) * 100).round
    end

    @result = current_user.personality_test_results.build(
      completed_at: Time.current,
      openness: normalized_scores[:openness],
      conscientiousness: normalized_scores[:conscientiousness],
      extraversion: normalized_scores[:extraversion],
      agreeableness: normalized_scores[:agreeableness],
      neuroticism: normalized_scores[:neuroticism]
    )

    if @result.save
      redirect_to applicants_personality_test_path, notice: "Personality test completed. Your results are active for 90 days."
    else
      flash.now[:alert] = "Failed to save results. Please try again."
      @questions = PersonalityTestResult::QUESTIONS
      @latest_result = current_user.personality_test_results.order(completed_at: :desc).first
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ensure_applicant!
    unless current_user.applicant?
      redirect_to root_path, alert: "Access denied. Only applicants can take the personality test."
    end
  end
end
