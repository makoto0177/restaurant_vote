Rails.application.routes.draw do
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider

  root 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create show destroy] do
    collection do 
      get 'search'
    end
    
    member do
      get 'vote'
    end
    resources :comments, only: %i[create destroy]
    resources :votes, only: %i[create]
    mount ActionCable.server => '/cable'
    resources :comments, only: %i[create destroy]
  end

  resources :restaurants, only: %i[index] do
    collection do
      get 'search'
    end
  end

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end