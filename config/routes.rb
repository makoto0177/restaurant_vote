Rails.application.routes.draw do
  root 'static_pages#top'
  resources :users, only: %i[new create]
  resources :posts, only: %i[index new create] do
    member do
      get 'vote'
    end
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