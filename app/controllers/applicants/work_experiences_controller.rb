class Applicants::WorkExperiencesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_applicant!
  before_action :set_profile

  def create
    @work_experience = @profile.work_experiences.build(work_experience_params)

    respond_to do |format|
      if @work_experience.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("work-experiences-list", partial: "applicants/work_experiences/work_experience", locals: { work_experience: @work_experience }),
            turbo_stream.replace("new-work-experience-form", partial: "applicants/work_experiences/form", locals: { profile: @profile, new_work_experience: WorkExperience.new }),
            turbo_stream.append("notifications", partial: "shared/toast", locals: { message: "Work experience added successfully!", type: :notice })
          ]
        end
        format.html { redirect_to applicants_profile_path, notice: "Work experience added." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new-work-experience-form", partial: "applicants/work_experiences/form", locals: { profile: @profile, new_work_experience: @work_experience }), status: :unprocessable_entity
        end
        format.html { redirect_to applicants_profile_path, alert: "Failed to add work experience." }
      end
    end
  end

  def destroy
    @work_experience = @profile.work_experiences.find(params[:id])
    @work_experience.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@work_experience),
          turbo_stream.append("notifications", partial: "shared/toast", locals: { message: "Work experience removed.", type: :notice })
        ]
      end
      format.html { redirect_to applicants_profile_path, notice: "Work experience removed." }
    end
  end

  private

  def ensure_applicant!
    redirect_to root_path, alert: "Access denied." unless current_user.applicant?
  end

  def set_profile
    @profile = current_user.applicant_profile
  end

  def work_experience_params
    params.require(:work_experience).permit(:company, :position, :start_date, :end_date, :current, :description)
  end
end
