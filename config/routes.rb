Rails.application.routes.draw do
  namespace :admin do
    get 'categories/index'
    get 'categories/new'
    get 'categories/create'
  end
  get 'about/index'
  root to: 'products#index'

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  resource :cart, only: [:show] do
    post   :add_item
    post   :remove_item
  end

  resources :orders, only: [:create, :show]

  namespace :admin do
    root to: 'dashboard#show'
    resources :products, except: [:edit, :update, :show]
    resources :categories, only: [:index, :new, :create]
  end

  get 'about', to: 'about#index', as: 'about'
  
end
