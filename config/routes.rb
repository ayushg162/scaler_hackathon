Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/create_group", to: "split#create_group"
      get "/get_groups", to: "split#get_groups"
      post "/split_payment", to: "split#split_payment"
      post "/get_expenses", to: "split#get_expenses"
      post "/make_group", to: "split#make_group"
      get "/get_transactions", to: "split#get_transactions"
      resources :split, only: [:index, :show, :create, :update, :create_group]
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
