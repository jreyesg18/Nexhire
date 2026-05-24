class JobOffersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @job_offers = JobOffer.order(created_at: :desc)
  end

  def show
    @job_offer = JobOffer.find(params[:id])
    if user_signed_in? && current_user.applicant?
      @already_applied = current_user.job_applications.exists?(job_offer: @job_offer)
      @valid_test = current_user.has_valid_test_result?
      @match_percentage = @job_offer.match_percentage_for_user(current_user) if @valid_test
    end
  end
end
