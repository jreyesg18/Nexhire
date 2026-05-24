class Recruiters::JobApplicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_recruiter!
  before_action :set_job_offer
  before_action :set_job_application, only: [ :show, :update_status ]

  def show
    @applicant = @job_application.applicant
    @profile = @applicant.applicant_profile
  end

  def update_status
    status = params[:status]

    if JobApplication::STATUSES.include?(status)
      if @job_application.update(status: status)
        redirect_to recruiters_job_offer_job_application_path(@job_offer, @job_application), notice: "Application status updated to #{status.capitalize}."
      else
        redirect_to recruiters_job_offer_job_application_path(@job_offer, @job_application), alert: "Failed to update status."
      end
    else
      redirect_to recruiters_job_offer_job_application_path(@job_offer, @job_application), alert: "Invalid status value."
    end
  end

  private

  def ensure_recruiter!
    unless current_user.recruiter?
      redirect_to root_path, alert: "Access denied."
    end
  end

  def set_job_offer
    @job_offer = current_user.job_offers.find(params[:job_offer_id])
  end

  def set_job_application
    @job_application = @job_offer.job_applications.find(params[:id])
  end
end
