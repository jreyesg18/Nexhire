class Applicants::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_applicant!

  def show
    @profile = current_user.applicant_profile || current_user.create_applicant_profile!(name: current_user.email.split("@").first.capitalize)
    @new_work_experience = WorkExperience.new
    @new_education = Education.new
  end

  def update
    @profile = current_user.applicant_profile
    if @profile.update(profile_params)
      redirect_to applicants_profile_path, notice: "Profile updated successfully."
    else
      @new_work_experience = WorkExperience.new
      @new_education = Education.new
      render :show, status: :unprocessable_entity
    end
  end

  private

  def ensure_applicant!
    unless current_user.applicant?
      redirect_to root_path, alert: "Access denied. Only applicants can view this section."
    end
  end

  def profile_params
    params.require(:applicant_profile).permit(:name, :skills, :photo)
  end
end
