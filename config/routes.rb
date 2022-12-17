Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/create_group", to: "split#create_group"
      resources :split, only: [:index, :show, :create, :update, :create_group]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
