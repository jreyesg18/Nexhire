class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.recruiter?
        redirect_to recruiters_job_offers_path
      else
        redirect_to job_offers_path
      end
    end
  end
end
