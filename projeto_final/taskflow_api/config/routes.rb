Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "api/v1/pipelines#index"

  namespace :api do
    namespace :v1 do
      resources :pipelines, only: [:index, :show, :create, :update, :destroy] do
        resources :tasks, only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
