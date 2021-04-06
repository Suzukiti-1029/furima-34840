Rails.application.routes.draw do
  devise_for :users
  root to: 'items#index'
  resources :items, except: :index do
    resource :comments, only: :create
    resource :residences, only: [:new, :create]
  end
end
