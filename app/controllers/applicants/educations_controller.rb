class Applicants::EducationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_applicant!
  before_action :set_profile

  def create
    @education = @profile.educations.build(education_params)

    respond_to do |format|
      if @education.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("educations-list", partial: "applicants/educations/education", locals: { education: @education }),
            turbo_stream.replace("new-education-form", partial: "applicants/educations/form", locals: { profile: @profile, new_education: Education.new }),
            turbo_stream.append("notifications", partial: "shared/toast", locals: { message: "Education entry added successfully!", type: :notice })
          ]
        end
        format.html { redirect_to applicants_profile_path, notice: "Education added." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new-education-form", partial: "applicants/educations/form", locals: { profile: @profile, new_education: @education }), status: :unprocessable_entity
        end
        format.html { redirect_to applicants_profile_path, alert: "Failed to add education." }
      end
    end
  end

  def destroy
    @education = @profile.educations.find(params[:id])
    @education.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(@education),
          turbo_stream.append("notifications", partial: "shared/toast", locals: { message: "Education entry removed.", type: :notice })
        ]
      end
      format.html { redirect_to applicants_profile_path, notice: "Education removed." }
    end
  end

  private

  def ensure_applicant!
    redirect_to root_path, alert: "Access denied." unless current_user.applicant?
  end

  def set_profile
    @profile = current_user.applicant_profile
  end

  def education_params
    params.require(:education).permit(:school, :degree, :field_of_study, :start_date, :end_date, :description)
  end
end
