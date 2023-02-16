Rails.application.routes.draw do
  get 'users/new'
  get 'users/create'
  root 'static_pages#top'

  resources :users, only: %i[new create]
end
