Rails.application.routes.draw do
  
  # Landing Page
  root 'landing#index'

  # Route for Devise
  devise_for :users

  # Route for Users to redirect to Profiles
  resources :users, only: [:show, :update], controller: :profiles

  # Route for Profiles
  resource :profile

  # Route for Photos and Comments
  resources :photos do
    resources :comments
  end
  
  # Route for Top 10 Trending Users
  get 'trending_users/index', as: "trending_users"
  
  # Route for Feed
  # get 'feed/index'
  get '/feed' => 'feed#index', as: "feed"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
