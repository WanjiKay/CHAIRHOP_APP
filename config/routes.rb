# config/routes.rb
Rails.application.routes.draw do
  # Root
  root "pages#home"

  devise_for :users

  # Health
  get "up" => "rails/health#show", as: :rails_health_check

  # --------- ADD PROFILE HERE ----------
  # GET /profile  -> profiles#show
  # PATCH /profile -> profiles#update
  resource :profile, only: [:show, :update]
   # redundant but harmless; ensures GET route
  # -------------------------------------

  # Existing routes from your app (based on your routes dump)
  resources :appointments do
    member { post :book }
    resources :chats, only: [:index, :new, :create, :show]
  end

  resources :chats, only: [:index, :new, :create, :show] do
    resources :messages, only: [:index, :create]
  end
  resources :chats, only: [:index, :show, :new, :create] do
    resources :messages, only: [:create]
  end
end
