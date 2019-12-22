Rails.application.routes.draw do
  root "static_pages#home"

  devise_for :users,
    controllers:{omniauth_callbacks: "omniauth_callbacks"}
  devise_scope :user do
    get "/users/:id", to: "devise_custom/registrations#show", as: :user
    get "/users/edit/:id", to: "devise/registrations#edit", as: :edit_user
    get "/admin/users/", to: "users#index", as: :admin_users
    get "/admin/user/:id/edit/", to: "users#edit", as: :edit_admin_user
    patch "/admin/users/:id/", to: "users#update", as: :admin_update_user
    delete "/admin/users/:id/", to: "users#destroy", as: :destroy_user
  end
  patch "pays/update"
  post "comment/create", to: "comments#create"
  get "/blog", to: "static_pages#blog"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  resources :pitches, only: :index do
    resources :subpitches, only: %i(index show)
  end
  resources :subpitches do
    resources :bookings, only: :new
  end
  resources :bookings do
    resources :pays, only: :new
  end
  namespace :admin do
    root "pages#home"
    resources :subpitch_types
    resources :pitches
  end
end
