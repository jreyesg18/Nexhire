class Recruiters::JobOffersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_recruiter!
  before_action :set_job_offer, only: [:show, :edit, :update, :destroy]

  def index
    @job_offers = current_user.job_offers.order(created_at: :desc)
  end

  def show
    # Sort job applications by their calculated match percentage in descending order
    @job_applications = @job_offer.job_applications.to_a.sort_by { |app| -app.match_percentage }
  end

  def new
    @job_offer = current_user.job_offers.build(
      ideal_openness: 50,
      ideal_conscientiousness: 50,
      ideal_extraversion: 50,
      ideal_agreeableness: 50,
      ideal_neuroticism: 50
    )
  end

  def create
    @job_offer = current_user.job_offers.build(job_offer_params)

    if @job_offer.save
      redirect_to recruiters_job_offers_path, notice: "Job offer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @job_offer.update(job_offer_params)
      redirect_to recruiters_job_offer_path(@job_offer), notice: "Job offer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_offer.destroy
    redirect_to recruiters_job_offers_path, notice: "Job offer was successfully deleted."
  end

  private

  def ensure_recruiter!
    unless current_user.recruiter?
      redirect_to root_path, alert: "Access denied. Only recruiters can access this area."
    end
  end

  def set_job_offer
    @job_offer = current_user.job_offers.find(params[:id])
  end

  def job_offer_params
    params.require(:job_offer).permit(
      :title, :company_name, :description, :location, :salary,
      :ideal_openness, :ideal_conscientiousness, :ideal_extraversion, :ideal_agreeableness, :ideal_neuroticism
    )
  end
end
