Rails.application.routes.draw do
  get "home", to: "home#home"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  delete "logout", to: "sessions#destroy"
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "contact", to: "index#contact"

  # Defines the root path route ("/")
  root "index#index"
end
