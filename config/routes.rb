Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq-status/web'

  mount Sidekiq::Web => '/sidekiq'
  resources :promotes, except: :edit do
    post 'start'
  end
  resources :clients
  resources :news
  resources :users
  devise_for :users,
             controllers: { sessions: 'sessions' },
             defaults: { format: :json },
             skip: :registrations,
             path: 'auth'
  devise_scope :user do
    get 'auth/current', to: 'sessions#show'
    post 'auth/totp', to: 'totp#create'
    post 'auth/send_code', to: 'totp#send_code'
    delete 'auth/totp', to: 'totp#delete'
  end
  resources :tasks do
    member do
      post 'subcontactors', action: 'add_subcontactor'
      delete 'subcontactors', action: 'delete_subcontactor'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
