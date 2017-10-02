Rails.application.routes.draw do
  
  

  root 'landing#index'
  devise_for :users
  resources :users, only: [:show, :update], controller: :profiles
  resource :profile
  resources :photos do
    resources :comments
  end
  
  get 'trending_users/index', as: "trending_users"
  # get 'feed/index'
  get '/feed' => 'feed#index', as: "feed"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
