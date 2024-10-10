Rails.application.routes.draw do
  get 'comments/index'
  get 'comments/new'
  get 'comments/edit'
  get 'comments/show'
  get 'users/index'
  devise_for :users
  resources :articles do
    member do
  
         put 'toggle_like', to: 'articles#toggle_like'
    end
  
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  
  resources :users do
    member do
      patch :approve
      patch :rejected
      patch :pending
      post 'send_friend_request', to: 'friendships#create'
    end

    collection do
      get 'friend_requests', to: 'users#friend_requests'  # Route for displaying pending friend requests
       get 'admin', to: 'users#admin'
   
    end
  end

  resources :friendships, only: [:create, :update, :destroy] do
    member do
      patch 'accept', to: 'friendships#update', defaults: { status: 'accept' }
      patch 'reject', to: 'friendships#update', defaults: { status: 'reject' }
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
root "articles#index"



get 'drafts', to: 'articles#drafts', as: 'drafts'
get 'cancel', to: 'users#cancel', as: 'cancel'
get 'users/:id/friends', to: 'users#friends', as: 'user_friends'


end
