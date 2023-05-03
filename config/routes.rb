Rails.application.routes.draw do
  root 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'privacy', to: 'static_pages#privacy'
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create show destroy] do
    member do
      get 'vote'
    end
    resources :votes, only: %i[create]
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