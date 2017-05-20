Rails.application.routes.draw do

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  scope :admin do
    get '/', to: 'admins#index', as: :admin
    delete '/toot/:id', to: 'admins#destroy', as: :delete_toot
    put '/fetch/:id', to: 'admins#fetch', as: :fetch
  end

  resources :toots, only: [:create]
  get '/api/instance', to: 'toots#api'
  root to: 'toots#index'

end
