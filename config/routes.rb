Rails.application.routes.draw do
  root "static_pages#home"
  namespace :admin do
    root "pages#home"
  end
  post "/login", to: "sessions#create"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  match "/auth/:provider/callback", to: "sessions#create", via: [:get, :post]
  match "/auth/failure", to: "sessions#failure", via: [:get, :post]
  get "/blog", to: "static_pages#blog"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  resources :password_resets, except: :index
  resources :account_activations, only: :edit
  resources :users
  resources :pitches, only: :index do
    resources :subpitches, only: %i(index show)
  end
end
