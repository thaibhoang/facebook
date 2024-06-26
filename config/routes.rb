Rails.application.routes.draw do
  get 'hangouts/index'
  get 'my_registrations/create'
  devise_for :users, controllers: { registrations: "my_registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "posts#index"
  resources :follow_requests do
    put "accept", on: :member
  end

  resources :posts do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: [:new, :create, :destroy]
  end

  resources :profile
  resources :users, only: :index
  resources :messages, only: [:create]
  resources :hangouts, only: [:index]
end
