class JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_applicant!

  def index
    @job_applications = current_user.job_applications.order(created_at: :desc)
  end

  def create
    @job_offer = JobOffer.find(params[:job_offer_id])
    
    unless current_user.has_valid_test_result?
      redirect_to applicants_personality_test_path, alert: "Your personality test has expired or is missing. Please take the OCEAN assessment to unlock applications."
      return
    end

    @job_application = current_user.job_applications.build(job_offer: @job_offer)

    if @job_application.save
      redirect_to job_applications_path, notice: "Successfully applied to #{@job_offer.title} at #{@job_offer.company_name}."
    else
      redirect_to job_offer_path(@job_offer), alert: @job_application.errors.full_messages.to_sentence
    end
  end

  def show
    @job_application = current_user.job_applications.find(params[:id])
  end

  private

  def ensure_applicant!
    unless current_user.applicant?
      redirect_to root_path, alert: "Access denied. Only job applicants can access this section."
    end
  end
end
