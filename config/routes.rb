# config/routes.rb
Rails.application.routes.draw do
  # Root
  root "pages#home"

  # Health
  get "up" => "rails/health#show", as: :rails_health_check

  # Profile
  resource :profile, only: [:show, :update]
  get "/profile", to: "profiles#show" # explicit GET, harmless redundancy

  # Appointments (no block)
  resources :appointments
  post "appointments/:id/book", to: "appointments#book", as: :book_appointment

  # Chats & messages (no nesting to avoid blocks for now)
  resources :chats, only: [:index, :new, :create, :show]
  resources :messages, only: [:index, :create]
end
