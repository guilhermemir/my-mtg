Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "home", to: "home#home"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"

  delete "logout", to: "sessions#destroy"

  resources :users
  resources :cards, only: [:index, :create, :update, :destroy] do
    collection do
      post :search
    end
  end

  get "contact", to: "index#contact"

  # Defines the root path route ("/")
  root "index#index"
end
