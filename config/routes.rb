Rails.application.routes.draw do
  devise_for :users

  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check

  # Job Offers and Applications for Applicants
  resources :job_offers, only: [ :index, :show ]
  resources :job_applications, only: [ :index, :create, :show ]

  # Applicant features
  namespace :applicants do
    resource :profile, only: [ :show, :update ]
    resources :work_experiences, only: [ :create, :destroy ]
    resources :educations, only: [ :create, :destroy ]
    resource :personality_test, only: [ :show, :new, :create ]
  end

  # Recruiter features
  namespace :recruiters do
    resources :job_offers do
      resources :job_applications, only: [ :show ] do
        member do
          patch :update_status
        end
      end
    end
  end
end
